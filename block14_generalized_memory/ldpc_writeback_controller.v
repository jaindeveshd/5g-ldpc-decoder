
`timescale 1ns/1ps

module ldpc_writeback_controller #(
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

    // Edge metadata interface
    input wire edge_valid,
    input wire edge_last,
    output wire edge_ready,

    input wire [5:0] row_index,
    input wire [6:0] col_index,
    input wire [8:0] shift_value,
    input wire [9:0] current_edge_addr,

    // Updated datapath vectors
    input wire data_valid,
    output wire data_ready,

    input wire [MAX_DEGREE*DATA_WIDTH-1:0] L_new_values,
    input wire [MAX_DEGREE*DATA_WIDTH-1:0] R_new_values,

    // LLR memory write interface
    output wire llr_en,
    output wire llr_we,
    output wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    output wire [DATA_WIDTH-1:0] llr_din,

    // Edge-message memory write interface
    output wire edge_en,
    output wire edge_we,
    output wire [EDGE_ADDR_WIDTH-1:0] edge_addr,
    output wire [DATA_WIDTH-1:0] edge_din,

    output reg [DEGREE_WIDTH-1:0] degree,
    output reg [8:0] lifted_index,

    output reg position_done,
    output reg busy,
    output reg layer_done,
    output reg error
);

    // ------------------------------------------------
    // FSM states
    // ------------------------------------------------

    localparam IDLE      = 3'd0;
    localparam CAPTURE   = 3'd1;
    localparam WAIT_DATA = 3'd2;
    localparam WRITE     = 3'd3;

    reg [2:0] state;

    // ------------------------------------------------
    // Configuration registers
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
    // Datapath vector registers
    // ------------------------------------------------

    reg [MAX_DEGREE*DATA_WIDTH-1:0] L_new_reg;
    reg [MAX_DEGREE*DATA_WIDTH-1:0] R_new_reg;

    wire [DATA_WIDTH-1:0] current_L_new;
    wire [DATA_WIDTH-1:0] current_R_new;

    assign current_L_new =
        L_new_reg[edge_ptr*DATA_WIDTH +: DATA_WIDTH];

    assign current_R_new =
        R_new_reg[edge_ptr*DATA_WIDTH +: DATA_WIDTH];

    // ------------------------------------------------
    // Address generator
    // ------------------------------------------------

    wire [LLR_ADDR_WIDTH-1:0] calculated_llr_addr;
    wire [EDGE_ADDR_WIDTH-1:0] calculated_edge_addr;
    wire [8:0] calculated_source_index;

    wire address_valid;
    wire address_error;

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
    // Handshakes
    // ------------------------------------------------

    assign edge_ready =
        (state == CAPTURE) &&
        (degree_count < MAX_DEGREE);

    assign data_ready = (state == WAIT_DATA);

    // ------------------------------------------------
    // Memory write interfaces
    // ------------------------------------------------

    assign llr_en =
        (state == WRITE) && address_valid;

    assign llr_we = llr_en;

    assign llr_addr = calculated_llr_addr;
    assign llr_din = current_L_new;

    assign edge_en =
        (state == WRITE) && address_valid;

    assign edge_we = edge_en;

    assign edge_addr = calculated_edge_addr;
    assign edge_din = current_R_new;

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

            L_new_reg <= 0;
            R_new_reg <= 0;

            position_done <= 1'b0;
            layer_done <= 1'b0;

            busy <= 1'b0;
            error <= 1'b0;

        end else begin

            // Pulse outputs default low.
            position_done <= 1'b0;
            layer_done <= 1'b0;

            case (state)

                // ====================================
                // IDLE
                // ====================================

                IDLE: begin

                    busy <= 1'b0;

                    if (start) begin

                        if ((zc >= 10'd2) &&
                            (zc <= 10'd384)) begin

                            bg_reg <= bg_select;
                            zc_reg <= zc;

                            degree_count <= 0;
                            degree <= 0;

                            edge_ptr <= 0;
                            lifted_index <= 0;

                            row_reg <= 0;

                            L_new_reg <= 0;
                            R_new_reg <= 0;

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

                                if (degree_count >= 1) begin

                                    degree <= degree_count + 1'b1;

                                    lifted_index <= 0;
                                    edge_ptr <= 0;

                                    state <= WAIT_DATA;

                                end else begin

                                    error <= 1'b1;
                                    busy <= 1'b0;
                                    state <= IDLE;

                                end

                            end else if (
                                degree_count == MAX_DEGREE-1
                            ) begin

                                error <= 1'b1;
                                busy <= 1'b0;
                                state <= IDLE;

                            end
                        end
                    end
                end

                // ====================================
                // WAIT FOR UPDATED DATAPATH VECTORS
                // ====================================

                WAIT_DATA: begin

                    if (data_valid && data_ready) begin

                        L_new_reg <= L_new_values;
                        R_new_reg <= R_new_values;

                        edge_ptr <= 0;

                        state <= WRITE;

                    end
                end

                // ====================================
                // WRITE UPDATED MESSAGES
                // ====================================

                WRITE: begin

                    if (!address_valid) begin

                        error <= 1'b1;
                        busy <= 1'b0;
                        state <= IDLE;

                    end else begin

                        // Memory samples both write enables
                        // at this clock edge.

                        if (edge_ptr == degree-1'b1) begin

                            // All edges for this lifted
                            // position have been written.
                            position_done <= 1'b1;

                            edge_ptr <= 0;

                            if (lifted_index == zc_reg-1'b1) begin

                                layer_done <= 1'b1;
                                busy <= 1'b0;

                                state <= IDLE;

                            end else begin

                                lifted_index <= lifted_index + 1'b1;

                                state <= WAIT_DATA;

                            end

                        end else begin

                            edge_ptr <= edge_ptr + 1'b1;

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

                    position_done <= 1'b0;
                    layer_done <= 1'b0;

                end

            endcase
        end
    end

endmodule
