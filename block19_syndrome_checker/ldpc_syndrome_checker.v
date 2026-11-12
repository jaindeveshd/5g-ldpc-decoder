
`timescale 1ns/1ps

module ldpc_syndrome_checker (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire bg_select,
    input wire [9:0] zc,

    output wire llr_en,
    output wire llr_we,
    output wire [14:0] llr_addr,
    input wire [7:0] llr_dout,

    output reg busy,
    output reg done,
    output reg syndrome_pass,
    output reg error
);

    // FSM states
    localparam IDLE         = 3'd0;
    localparam START_ROW    = 3'd1;
    localparam WAIT_EDGE    = 3'd2;
    localparam READ_REQ     = 3'd3;
    localparam CAPTURE_READ = 3'd4;
    localparam WAIT_LAYER   = 3'd5;
    localparam FINISH       = 3'd6;

    reg [2:0] state;

    // Captured decoder configuration
    reg bg_reg;
    reg [9:0] zc_reg;
    reg [5:0] row_reg;
    reg [8:0] lifted_index;

    // Syndrome accumulation
    reg parity_accum;
    reg syndrome_fail;

    // Validate external configuration before accepting start
    wire input_cfg_valid;
    wire [2:0] input_i_ls;

    lifting_size_decoder U_INPUT_CONFIG (
        .zc(zc),
        .valid(input_cfg_valid),
        .i_ls(input_i_ls)
    );

    // Configuration and layer address generation
    wire cfg_valid_unused;
    wire [2:0] i_ls_unused;

    wire edge_valid;
    wire edge_last;
    wire layer_done;
    wire layer_busy;
    wire layer_start_error;

    wire [5:0] row_index;
    wire [6:0] col_index;
    wire [8:0] shift_value;
    wire [9:0] current_edge_addr;

    ldpc_config_layer U_CONFIG_LAYER (
        .clk(clk),
        .rst_n(rst_n),
        .start(state == START_ROW),
        .bg_select(bg_reg),
        .layer_index(row_reg),
        .zc(zc_reg),
        .edge_ready(state == CAPTURE_READ),
        .cfg_valid(cfg_valid_unused),
        .i_ls(i_ls_unused),
        .edge_valid(edge_valid),
        .edge_last(edge_last),
        .layer_done(layer_done),
        .busy(layer_busy),
        .start_error(layer_start_error),
        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr)
    );

    // Generate the shifted LLR memory address
    wire [17:0] edge_addr_unused;
    wire [8:0] source_index;
    wire address_valid;
    wire address_error;

    ldpc_edge_address_generator U_ADDRESS_GENERATOR (
        .bg_select(bg_reg),
        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),
        .zc(zc_reg),
        .lifted_index(lifted_index),
        .llr_addr(llr_addr),
        .edge_addr(edge_addr_unused),
        .source_index(source_index),
        .address_valid(address_valid),
        .address_error(address_error)
    );

    // Read-only LLR memory interface
    assign llr_en = (state == READ_REQ) && address_valid;
    assign llr_we = 1'b0;

    // Main syndrome FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;

            bg_reg        <= 1'b0;
            zc_reg        <= 10'd0;
            row_reg       <= 6'd0;
            lifted_index  <= 9'd0;

            parity_accum  <= 1'b0;
            syndrome_fail <= 1'b0;

            busy          <= 1'b0;
            done          <= 1'b0;
            syndrome_pass <= 1'b0;
            error         <= 1'b0;
        end
        else begin
            done <= 1'b0;

            case (state)

                // Wait for a valid syndrome-check request
                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        error         <= 1'b0;
                        syndrome_pass <= 1'b0;

                        if (!input_cfg_valid) begin
                            error <= 1'b1;
                            done  <= 1'b1;
                        end
                        else begin
                            bg_reg        <= bg_select;
                            zc_reg        <= zc;
                            row_reg       <= 6'd0;
                            lifted_index  <= 9'd0;

                            parity_accum  <= 1'b0;
                            syndrome_fail <= 1'b0;

                            busy  <= 1'b1;
                            state <= START_ROW;
                        end
                    end
                end

                // Start processing the selected base-graph row
                START_ROW: begin
                    state <= WAIT_EDGE;
                end

                // Wait for the next valid edge from the BG ROM
                WAIT_EDGE: begin
                    if (layer_start_error || address_error) begin
                        error <= 1'b1;
                        state <= FINISH;
                    end
                    else if (edge_valid) begin
                        if (address_valid)
                            state <= READ_REQ;
                        else begin
                            error <= 1'b1;
                            state <= FINISH;
                        end
                    end
                end

                // Issue synchronous LLR memory read
                READ_REQ: begin
                    state <= CAPTURE_READ;
                end

                // Capture the LLR hard decision
                CAPTURE_READ: begin
                    // Signed LLR convention:
                    // Negative LLR -> bit 1
                    // Zero/positive LLR -> bit 0
                    parity_accum <= parity_accum ^ llr_dout[7];

                    if (edge_last)
                        state <= WAIT_LAYER;
                    else
                        state <= WAIT_EDGE;
                end

                // Wait until all edges in this row are processed
                WAIT_LAYER: begin
                    if (layer_done) begin

                        if (parity_accum)
                            syndrome_fail <= 1'b1;

                        // Final row and final lifted position
                        if ((row_reg == (bg_reg ? 6'd41 : 6'd45)) &&
                            (lifted_index == zc_reg - 10'd1)) begin

                            syndrome_pass <=
                                !(syndrome_fail || parity_accum);

                            busy  <= 1'b0;
                            state <= FINISH;
                        end

                        // Process the next lifted position
                        else if (lifted_index < zc_reg - 10'd1) begin
                            lifted_index <= lifted_index + 9'd1;
                            parity_accum <= 1'b0;
                            state        <= START_ROW;
                        end

                        // Move to the next base-graph row
                        else begin
                            row_reg      <= row_reg + 6'd1;
                            lifted_index <= 9'd0;
                            parity_accum <= 1'b0;
                            state        <= START_ROW;
                        end
                    end
                end

                // Finish and return to idle
                FINISH: begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    error <= 1'b1;
                    busy  <= 1'b0;
                    state <= FINISH;
                end

            endcase
        end
    end

endmodule
