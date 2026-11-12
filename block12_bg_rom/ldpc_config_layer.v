
`timescale 1ns/1ps

module ldpc_config_layer (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,

    input  wire       bg_select,
    input  wire [5:0] layer_index,
    input  wire [9:0] zc,
    input  wire       edge_ready,

    output wire       cfg_valid,
    output wire [2:0] i_ls,

    output wire       edge_valid,
    output wire       edge_last,
    output wire       layer_done,
    output wire       busy,
    output wire       start_error,

    output wire [5:0] row_index,
    output wire [6:0] col_index,
    output wire [8:0] shift_value,
    output wire [9:0] current_edge_addr
);

    wire layer_start_error;
    reg  invalid_cfg_error;

    // Decode Zc into its standardized lifting-size set.
    lifting_size_decoder U_LS_DECODER (
        .zc(zc),
        .i_ls(i_ls),
        .valid(cfg_valid)
    );

    // Start the layer generator only with a legal Zc.
    layer_address_generator U_LAYER_GENERATOR (
        .clk(clk),
        .rst_n(rst_n),
        .start(start && cfg_valid),
        .bg_select(bg_select),
        .layer_index(layer_index),
        .i_ls(i_ls),
        .zc(zc),
        .edge_ready(edge_ready),

        .edge_valid(edge_valid),
        .edge_last(edge_last),
        .layer_done(layer_done),
        .busy(busy),
        .start_error(layer_start_error),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr)
    );

    // Report an invalid lifting-size configuration.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            invalid_cfg_error <= 1'b0;
        else begin
            invalid_cfg_error <= 1'b0;

            if (start && !cfg_valid && !busy)
                invalid_cfg_error <= 1'b1;
        end
    end

    assign start_error = invalid_cfg_error | layer_start_error;

endmodule
