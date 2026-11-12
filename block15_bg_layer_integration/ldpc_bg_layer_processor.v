
`timescale 1ns/1ps

module ldpc_bg_layer_processor #(
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
    input wire [5:0] layer_index,
    input wire [9:0] zc,

    output wire llr_en,
    output wire llr_we,
    output wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    output wire [DATA_WIDTH-1:0] llr_din,
    input wire signed [DATA_WIDTH-1:0] llr_dout,

    output wire edge_mem_en,
    output wire edge_mem_we,
    output wire [EDGE_ADDR_WIDTH-1:0] edge_mem_addr,
    output wire [DATA_WIDTH-1:0] edge_mem_din,
    input wire signed [DATA_WIDTH-1:0] edge_mem_dout,

    output wire cfg_valid,
    output wire [2:0] i_ls,
    output wire start_error,

    output wire busy,
    output reg layer_done,
    output wire error,

    output wire [DEGREE_WIDTH-1:0] degree,
    output wire [8:0] lifted_index
);

    // Internal signals
    wire edge_ready;

    wire config_edge_valid;
    wire config_edge_last;
    wire config_layer_done;
    wire config_busy;
    wire config_start_error;

    wire [5:0] row_index;
    wire [6:0] col_index;
    wire [8:0] shift_value;
    wire [9:0] current_edge_addr;

    wire processor_busy;
    wire processor_done;
    wire processor_error;

    wire layer_index_valid;
    wire launch;
    wire processor_start;

    // Sticky error register
    reg start_error_latched;

    // Validate the requested layer range
    assign layer_index_valid =
        (bg_select == 1'b0) ?
        (layer_index < 6'd46) :
        (layer_index < 6'd42);

    assign launch = start && !busy;

    assign processor_start =
        launch && cfg_valid && layer_index_valid;

    // Block 12: Configuration and edge generation
    ldpc_config_layer CONFIG (
        .clk(clk),
        .rst_n(rst_n),
        .start(launch),

        .bg_select(bg_select),
        .layer_index(layer_index),
        .zc(zc),
        .edge_ready(edge_ready),

        .cfg_valid(cfg_valid),
        .i_ls(i_ls),

        .edge_valid(config_edge_valid),
        .edge_last(config_edge_last),
        .layer_done(config_layer_done),
        .busy(config_busy),
        .start_error(config_start_error),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr)
    );

    // Block 14E: Generalized layer processor
    ldpc_layer_processing_wrapper #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DEGREE(MAX_DEGREE),
        .DEGREE_WIDTH(DEGREE_WIDTH),
        .LLR_ADDR_WIDTH(LLR_ADDR_WIDTH),
        .EDGE_ADDR_WIDTH(EDGE_ADDR_WIDTH)
    ) PROCESSOR (
        .clk(clk),
        .rst_n(rst_n),
        .start(processor_start),

        .bg_select(bg_select),
        .zc(zc),

        .edge_valid(config_edge_valid),
        .edge_ready(edge_ready),
        .edge_last(config_edge_last),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout),

        .edge_mem_en(edge_mem_en),
        .edge_mem_we(edge_mem_we),
        .edge_mem_addr(edge_mem_addr),
        .edge_mem_din(edge_mem_din),
        .edge_mem_dout(edge_mem_dout),

        .busy(processor_busy),
        .layer_done(processor_done),
        .error(processor_error),

        .degree(degree),
        .lifted_index(lifted_index)
    );

    // Top-level status
    assign busy = config_busy || processor_busy;

    // Error remains asserted until reset or another start.
    assign start_error = start_error_latched;

    assign error = start_error_latched || processor_error;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_error_latched <= 1'b0;
        end
        else begin
            if (launch)
                start_error_latched <= 1'b0;
            else if (config_start_error)
                start_error_latched <= 1'b1;
        end
    end

    // Combined completion handshake
    reg config_done_seen;
    reg processor_done_seen;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            config_done_seen <= 1'b0;
            processor_done_seen <= 1'b0;
            layer_done <= 1'b0;
        end
        else begin
            layer_done <= 1'b0;

            if (launch) begin
                config_done_seen <= 1'b0;
                processor_done_seen <= 1'b0;
            end
            else begin
                if (config_layer_done)
                    config_done_seen <= 1'b1;

                if (processor_done)
                    processor_done_seen <= 1'b1;

                if ((config_done_seen || config_layer_done) &&
                    (processor_done_seen || processor_done)) begin

                    layer_done <= 1'b1;

                    config_done_seen <= 1'b0;
                    processor_done_seen <= 1'b0;
                end
            end
        end
    end

endmodule
