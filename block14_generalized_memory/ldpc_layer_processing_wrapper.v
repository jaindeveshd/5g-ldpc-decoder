
`timescale 1ns/1ps

module ldpc_layer_processing_wrapper #(
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

    // Edge metadata from Block 12
    input wire edge_valid,
    output wire edge_ready,
    input wire edge_last,
    input wire [5:0] row_index,
    input wire [6:0] col_index,
    input wire [8:0] shift_value,
    input wire [9:0] current_edge_addr,

    // LLR memory interface
    output wire llr_en,
    output wire llr_we,
    output wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    output wire [DATA_WIDTH-1:0] llr_din,
    input wire signed [DATA_WIDTH-1:0] llr_dout,

    // Edge-message memory interface
    output wire edge_mem_en,
    output wire edge_mem_we,
    output wire [EDGE_ADDR_WIDTH-1:0] edge_mem_addr,
    output wire [DATA_WIDTH-1:0] edge_mem_din,
    input wire signed [DATA_WIDTH-1:0] edge_mem_dout,

    // Status
    output wire busy,
    output reg layer_done,
    output wire error,
    output wire [DEGREE_WIDTH-1:0] degree,
    output wire [8:0] lifted_index
);

    // ================================================
    // METADATA HANDSHAKE
    // ================================================

    wire gather_edge_ready;
    wire writeback_edge_ready;
    wire accepted_edge_valid;

    assign edge_ready =
        gather_edge_ready && writeback_edge_ready;

    assign accepted_edge_valid =
        edge_valid && edge_ready;

    // ================================================
    // GATHER CONTROLLER SIGNALS
    // ================================================

    wire gather_llr_en;
    wire gather_edge_en;

    wire [LLR_ADDR_WIDTH-1:0] gather_llr_addr;
    wire [EDGE_ADDR_WIDTH-1:0] gather_edge_addr;

    wire [DEGREE_WIDTH-1:0] gather_degree;
    wire [8:0] gather_lifted_index;

    wire [MAX_DEGREE*DATA_WIDTH-1:0] L_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] R_old_values;

    wire gathered_valid;
    wire gathered_ready;

    wire gather_busy;
    wire gather_done;
    wire gather_error;

    // ================================================
    // WRITEBACK CONTROLLER SIGNALS
    // ================================================

    wire write_llr_en;
    wire write_edge_en;

    wire [LLR_ADDR_WIDTH-1:0] write_llr_addr;
    wire [EDGE_ADDR_WIDTH-1:0] write_edge_addr;

    wire [DATA_WIDTH-1:0] write_llr_din;
    wire [DATA_WIDTH-1:0] write_edge_din;

    wire data_ready;
    wire position_done;

    wire writeback_busy;
    wire writeback_done;
    wire writeback_error;

    // ================================================
    // CNU-VNU DATAPATH SIGNALS
    // ================================================

    wire [MAX_DEGREE*DATA_WIDTH-1:0] Q_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] R_new_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] L_new_values;

    wire [DATA_WIDTH-1:0] min1;
    wire [DATA_WIDTH-1:0] min2;

    // ================================================
    // GATHERED-DATA HANDSHAKE
    // ================================================

    // Gather advances only after all writes for the
    // current lifted position have completed.
    assign gathered_ready = position_done;

    // Prevent the same gathered vector from being
    // accepted again during the position_done cycle.
    wire writeback_data_valid;

    assign writeback_data_valid =
        gathered_valid && !position_done;

    // ================================================
    // GENERALIZED CNU-VNU DATAPATH
    // ================================================

    generalized_cnu_vnu_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DEGREE(MAX_DEGREE),
        .DEGREE_WIDTH(DEGREE_WIDTH)
    ) DATAPATH (
        .degree(gather_degree),
        .L_values(L_values),
        .R_old_values(R_old_values),
        .Q_values(Q_values),
        .R_new_values(R_new_values),
        .L_new_values(L_new_values),
        .min1(min1),
        .min2(min2)
    );

    // ================================================
    // EDGE GATHER CONTROLLER
    // ================================================

    ldpc_edge_gather_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DEGREE(MAX_DEGREE),
        .DEGREE_WIDTH(DEGREE_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) GATHER (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .zc(zc),

        .edge_valid(accepted_edge_valid),
        .edge_last(edge_last),
        .edge_ready(gather_edge_ready),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),

        .llr_en(gather_llr_en),
        .llr_we(),
        .llr_addr(gather_llr_addr),
        .llr_din(),
        .llr_dout(llr_dout),

        .edge_en(gather_edge_en),
        .edge_we(),
        .edge_addr(gather_edge_addr),
        .edge_din(),
        .edge_dout(edge_mem_dout),

        .degree(gather_degree),
        .lifted_index(gather_lifted_index),
        .L_values(L_values),
        .R_old_values(R_old_values),

        .gathered_valid(gathered_valid),
        .gathered_ready(gathered_ready),

        .busy(gather_busy),
        .layer_done(gather_done),
        .error(gather_error)
    );

    // ================================================
    // MESSAGE WRITEBACK CONTROLLER
    // ================================================

    ldpc_writeback_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DEGREE(MAX_DEGREE),
        .DEGREE_WIDTH(DEGREE_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) WRITEBACK (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),

        .bg_select(bg_select),
        .zc(zc),

        .edge_valid(accepted_edge_valid),
        .edge_last(edge_last),
        .edge_ready(writeback_edge_ready),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),

        .data_valid(writeback_data_valid),
        .data_ready(data_ready),

        .L_new_values(L_new_values),
        .R_new_values(R_new_values),

        .llr_en(write_llr_en),
        .llr_we(),
        .llr_addr(write_llr_addr),
        .llr_din(write_llr_din),

        .edge_en(write_edge_en),
        .edge_we(),
        .edge_addr(write_edge_addr),
        .edge_din(write_edge_din),

        .degree(),
        .lifted_index(),

        .position_done(position_done),

        .busy(writeback_busy),
        .layer_done(writeback_done),
        .error(writeback_error)
    );

    // ================================================
    // SHARED MEMORY INTERFACES
    // ================================================

    // LLR memory:
    // Read during gathering, write during writeback.

    assign llr_en =
        gather_llr_en || write_llr_en;

    assign llr_we = write_llr_en;

    assign llr_addr =
        write_llr_en ?
        write_llr_addr : gather_llr_addr;

    assign llr_din = write_llr_din;

    // Edge-message memory:
    // Read during gathering, write during writeback.

    assign edge_mem_en =
        gather_edge_en || write_edge_en;

    assign edge_mem_we = write_edge_en;

    assign edge_mem_addr =
        write_edge_en ?
        write_edge_addr : gather_edge_addr;

    assign edge_mem_din = write_edge_din;

    // ================================================
    // SYNCHRONIZED COMPLETION
    // ================================================

    reg gather_done_seen;
    reg writeback_done_seen;

    always @(posedge clk) begin

        if (!rst_n) begin

            gather_done_seen <= 1'b0;
            writeback_done_seen <= 1'b0;
            layer_done <= 1'b0;

        end else begin

            layer_done <= 1'b0;

            if (start) begin

                gather_done_seen <= 1'b0;
                writeback_done_seen <= 1'b0;

            end else begin

                if (gather_done)
                    gather_done_seen <= 1'b1;

                if (writeback_done)
                    writeback_done_seen <= 1'b1;

                if ((gather_done_seen || gather_done) &&
                    (writeback_done_seen || writeback_done)) begin

                    layer_done <= 1'b1;

                    gather_done_seen <= 1'b0;
                    writeback_done_seen <= 1'b0;

                end
            end
        end
    end

    // ================================================
    // STATUS OUTPUTS
    // ================================================

    assign busy =
        gather_busy || writeback_busy;

    assign error =
        gather_error || writeback_error;

    assign degree = gather_degree;
    assign lifted_index = gather_lifted_index;

endmodule
