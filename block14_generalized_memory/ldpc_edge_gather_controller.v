
`timescale 1ns/1ps

module ldpc_edge_gather_controller #(
    parameter DATA_WIDTH = 8,
    parameter MAX_DEGREE = 19,
    parameter DEGREE_WIDTH = 5,
    parameter LLR_ADDR_WIDTH = 15,
    parameter EDGE_ADDR_WIDTH = 18
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire bg_select,
    input wire [9:0] zc,

    // Edge metadata from Block 12 layer address generator
    input wire edge_valid,
    input wire edge_last,
    output wire edge_ready,

    input wire [5:0] row_index,
    input wire [6:0] col_index,
    input wire [8:0] shift_value,
    input wire [9:0] current_edge_addr,

    // LLR memory read interface
    output wire llr_en,
    output wire llr_we,
    output wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    output wire [DATA_WIDTH-1:0] llr_din,
    input wire signed [DATA_WIDTH-1:0] llr_dout,

    // Edge-message memory read interface
    output wire edge_en,
    output wire edge_we,
    output wire [EDGE_ADDR_WIDTH-1:0] edge_addr,
    output wire [DATA_WIDTH-1:0] edge_din,
    input wire signed [DATA_WIDTH-1:0] edge_dout,

    // Gathered datapath values
    output reg [DEGREE_WIDTH-1:0] degree,
    output reg [8:0] lifted_index,
    output reg [MAX_DEGREE*DATA_WIDTH-1:0] L_values,
    output reg [MAX_DEGREE*DATA_WIDTH-1:0] R_old_values,

    // Gathered-data handshake
    output reg gathered_valid,
    input wire gathered_ready,

    output reg busy,
    output reg layer_done,
    output reg error
);

    // ------------------------------------------------
    // FSM states
    // ------------------------------------------------

    localparam IDLE        = 3'd0;
    localparam CAPTURE     = 3'd1;
    localparam ISSUE_READ  = 3'd2;
    localparam CAPTURE_READ= 3'd3;
    localparam PRESENT     = 3'd4;

    reg [2:0] state;

    // ------------------------------------------------
    // Latched row configuration
    // ------------------------------------------------

    reg bg_reg;
    reg [9:0] zc_reg;
    reg [5:0] row_reg;

    reg [DEGREE_WIDTH-1:0] degree_count;
    reg [DEGREE_WIDTH-1:0] edge_ptr;

    // ------------------------------------------------
    // Edge metadata storage
    // ------------------------------------------------

    reg [6:0] col_table [0:MAX_DEGREE-1];
    reg [8:0] shift_table [0:MAX_DEGREE-1];
    reg [9:0] edge_table [0:MAX_DEGREE-1];

    // ------------------------------------------------
    // Address generator signals
    // ------------------------------------------------

    wire [LLR_ADDR_WIDTH-1:0] calculated_llr_addr;
    wire [EDGE_ADDR_WIDTH-1:0] calculated_edge_addr;
    wire [8:0] calculated_source_index;

    wire address_valid;
    wire address_error;

    // ------------------------------------------------
    // Handshake and memory interface
    // ------------------------------------------------

    assign edge_ready =
        (state == CAPTURE) &&
        (degree_count < MAX_DEGREE);

    // Memory reads are requested during ISSUE_READ.
    // The synchronous memory samples the request at
    // the clock edge leaving ISSUE_READ.
    assign llr_en =
        (state == ISSUE_READ) && address_valid;

    assign edge_en =
        (state == ISSUE_READ) && address_valid;

    // This controller only reads in the gather phase.
    assign llr_we = 1'b0;
    assign edge_we = 1'b0;

    assign llr_addr = calculated_llr_addr;
    assign edge_addr = calculated_edge_addr;

    assign llr_din = {DATA_WIDTH{1'b0}};
    assign edge_din = {DATA_WIDTH{1'b0}};

    // ------------------------------------------------
    // Edge address generator
    // ------------------------------------------------

    ldpc_edge_address_generator #(
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH),
        .INDEX_WIDTH(9)
    ) ADDRESS_GENERATOR (
        .bg_select(bg_reg),
        .row_index(row_reg),
        .col_index(col_table[edge_ptr]),
        .shift_value(shift_table[edge_ptr]),
        .current_edge_addr(edge_table[edge_ptr]),
        .zc(zc_reg),
        .lifted_index(lifted_index),

        .llr_addr(calculated_llr_addr),
        .edge_addr(calculated_edge_addr),
        .source_index(calculated_source_index),
        .address_valid(address_valid),
        .address_error(address_error)
    );

    // ------------------------------------------------
    // Main controller
    // ------------------------------------------------

    always @(posedge clk) begin

        if (!rst_n) begin

            state <= IDLE;

            bg_reg <= 1'b0;
            zc_reg <= 10'd0;
            row_reg <= 6'd0;

            degree <= 0;
            degree_count <= 0;
            edge_ptr <= 0;

            lifted_index <= 0;

            L_values <= 0;
            R_old_values <= 0;

            gathered_valid <= 1'b0;

            busy <= 1'b0;
            layer_done <= 1'b0;
            error <= 1'b0;

        end else begin

            // Pulse outputs default low every cycle.
            layer_done <= 1'b0;

            case (state)

                // ====================================
                // IDLE
                // ====================================

                IDLE: begin

                    gathered_valid <= 1'b0;
                    busy <= 1'b0;

                    if (start) begin

                        if ((zc >= 10'd2) &&
                            (zc <= 10'd384)) begin

                            bg_reg <= bg_select;
                            zc_reg <= zc;

                            lifted_index <= 0;
                            row_reg <= 0;

                            degree_count <= 0;
                            degree <= 0;
                            edge_ptr <= 0;

                            L_values <= 0;
                            R_old_values <= 0;

                            error <= 1'b0;
                            busy <= 1'b1;

                            state <= CAPTURE;

                        end else begin

                            error <= 1'b1;

                        end
                    end
                end

                // ====================================
                // CAPTURE EDGE METADATA
                // ====================================

                CAPTURE: begin

                    if (edge_valid && edge_ready) begin

                        if (degree_count == 0)
                            row_reg <= row_index;

                        if ((degree_count != 0) &&
                            (row_index != row_reg)) begin

                            error <= 1'b1;
                            busy <= 1'b0;
                            state <= IDLE;

                        end else begin

                            col_table[degree_count] <= col_index;
                            shift_table[degree_count] <= shift_value;
                            edge_table[degree_count] <= current_edge_addr;

                            degree_count <= degree_count + 1'b1;

                            if (edge_last) begin

                                // A CNU requires degree >= 2.
                                if (degree_count >= 1) begin

                                    degree <= degree_count + 1'b1;
                                    edge_ptr <= 0;
                                    lifted_index <= 0;

                                    L_values <= 0;
                                    R_old_values <= 0;

                                    state <= ISSUE_READ;

                                end else begin

                                    error <= 1'b1;
                                    busy <= 1'b0;
                                    state <= IDLE;

                                end
                            end
                        end
                    end

                    // Metadata overflow or missing capacity.
                    if (edge_valid && !edge_ready) begin

                        error <= 1'b1;
                        busy <= 1'b0;
                        state <= IDLE;

                    end
                end

                // ====================================
                // ISSUE SYNCHRONOUS MEMORY READ
                // ====================================

                ISSUE_READ: begin

                    if (address_valid) begin

                        // llr_en and edge_en are asserted
                        // combinationally in this state.
                        // Synchronous memories sample them
                        // at this clock edge.
                        state <= CAPTURE_READ;

                    end else begin

                        error <= 1'b1;
                        busy <= 1'b0;
                        state <= IDLE;

                    end
                end

                // ====================================
                // CAPTURE MEMORY OUTPUTS
                // ====================================

                CAPTURE_READ: begin

                    L_values[
                        edge_ptr*DATA_WIDTH +: DATA_WIDTH
                    ] <= llr_dout;

                    R_old_values[
                        edge_ptr*DATA_WIDTH +: DATA_WIDTH
                    ] <= edge_dout;

                    if (edge_ptr == degree - 1'b1) begin

                        state <= PRESENT;

                    end else begin

                        edge_ptr <= edge_ptr + 1'b1;
                        state <= ISSUE_READ;

                    end
                end

                // ====================================
                // PRESENT GATHERED VECTORS
                // ====================================

                PRESENT: begin

                    gathered_valid <= 1'b1;

                    if (gathered_valid && gathered_ready) begin

                        gathered_valid <= 1'b0;

                        // All lifted positions for this row
                        // have now been gathered.
                        if (lifted_index == zc_reg - 1'b1) begin

                            layer_done <= 1'b1;
                            busy <= 1'b0;
                            state <= IDLE;

                        end else begin

                            lifted_index <= lifted_index + 1'b1;

                            edge_ptr <= 0;

                            L_values <= 0;
                            R_old_values <= 0;

                            state <= ISSUE_READ;

                        end
                    end
                end

                // ====================================
                // INVALID STATE
                // ====================================

                default: begin

                    state <= IDLE;
                    busy <= 1'b0;
                    error <= 1'b1;
                    gathered_valid <= 1'b0;

                end

            endcase
        end
    end

endmodule
