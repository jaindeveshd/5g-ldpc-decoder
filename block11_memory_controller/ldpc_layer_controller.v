
`timescale 1ns/1ps

module ldpc_layer_controller #(
    parameter ADDR_WIDTH = 7,
    parameter LAYER_ADDR_WIDTH = 6,
    parameter ITER_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter NUM_SYNDROME_ROWS = 4,
    parameter ROW_ADDR_WIDTH = 2
)(
    input wire clk,
    input wire rst_n,

    // Decoder configuration
    input wire start,
    input wire [LAYER_ADDR_WIDTH-1:0] num_layers,
    input wire [ITER_WIDTH-1:0] max_iterations,

    // External layer ROM interface
    output wire rom_en,
    output wire [LAYER_ADDR_WIDTH-1:0] rom_addr,
    input wire rom_valid,
    input wire [ADDR_WIDTH-1:0] rom_base_addr,

    // External syndrome-row data interface
    input wire [DATA_WIDTH-1:0] hard_bits,
    input wire row_valid,
    input wire [DATA_WIDTH-1:0] row_mask,

    // Decoder status
    output wire busy,
    output wire done,
    output wire [ITER_WIDTH-1:0] iteration_count,

    // Debug / integration visibility
    output wire layer_start,
    output wire datapath_busy,
    output wire datapath_done,
    output wire syndrome_start,
    output wire syndrome_busy,
    output wire syndrome_done,
    output wire syndrome_pass,

    // Datapath observation
    output wire [31:0] L_values,
    output wire [31:0] R_old_values,
    output wire [31:0] Q_values,
    output wire [31:0] R_new_values,
    output wire [31:0] L_new_values,
    output wire [7:0] min1,
    output wire [7:0] min2
);

    // ------------------------------------------------
    // Block 9: Layered decoding FSM
    // ------------------------------------------------

    layered_fsm #(
        .LAYER_ADDR_WIDTH(LAYER_ADDR_WIDTH),
        .ITER_WIDTH(ITER_WIDTH)
    ) FSM (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .num_layers(num_layers),
        .max_iterations(max_iterations),

        .rom_en(rom_en),
        .rom_addr(rom_addr),
        .rom_valid(rom_valid),

        .layer_start(layer_start),
        .layer_done(datapath_done),

        .syndrome_start(syndrome_start),
        .syndrome_done(syndrome_done),
        .syndrome_pass(syndrome_pass),

        .busy(busy),
        .done(done),
        .iteration_count(iteration_count)
    );

    // ------------------------------------------------
    // Block 11B: SRAM + CNU-VNU datapath
    // ------------------------------------------------

    memory_datapath_wrapper #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) DATAPATH (
        .clk(clk),
        .rst_n(rst_n),

        .start(layer_start),
        .base_addr(rom_base_addr),

        .busy(datapath_busy),
        .done(datapath_done),
        .compute_start(),

        .L_values(L_values),
        .R_old_values(R_old_values),
        .Q_values(Q_values),
        .R_new_values(R_new_values),
        .L_new_values(L_new_values),

        .min1(min1),
        .min2(min2)
    );

    // ------------------------------------------------
    // Block 10: Actual syndrome checker
    // ------------------------------------------------

    syndrome_checker #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_ROWS(NUM_SYNDROME_ROWS),
        .ROW_ADDR_WIDTH(ROW_ADDR_WIDTH)
    ) SYNDROME (
        .clk(clk),
        .rst_n(rst_n),

        .hard_bits(hard_bits),
        .row_valid(row_valid),
        .row_mask(row_mask),

        .start(syndrome_start),

        .busy(syndrome_busy),
        .done(syndrome_done),
        .syndrome_pass(syndrome_pass)
    );

endmodule
