
`timescale 1ns/1ps

module memory_datapath_wrapper #(
    parameter ADDR_WIDTH = 7
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [ADDR_WIDTH-1:0] base_addr,

    output wire busy,
    output wire done,
    output wire compute_start,

    output wire [31:0] L_values,
    output wire [31:0] R_old_values,
    output wire [31:0] Q_values,
    output wire [31:0] R_new_values,
    output wire [31:0] L_new_values,

    output wire [7:0] min1,
    output wire [7:0] min2
);

    // Memory controller <-> SRAM signals
    wire we_a, we_b;
    wire [ADDR_WIDTH-1:0] addr_a, addr_b;
    wire [7:0] din_a, din_b;
    wire [7:0] dout_a, dout_b;

    // Instantiate the memory controller
    memory_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) CTRL (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .base_addr(base_addr),
        .busy(busy),
        .done(done),
        .compute_start(compute_start),

        .L_new(L_new_values),
        .R_new(R_new_values),

        .L_values(L_values),
        .R_old_values(R_old_values),

        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),

        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Instantiate the dual-port LLR SRAM
    llr_sram MEM (
        .clk(clk),

        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),

        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Unpack the four variable-node LLRs
    wire signed [7:0] L0 = L_values[7:0];
    wire signed [7:0] L1 = L_values[15:8];
    wire signed [7:0] L2 = L_values[23:16];
    wire signed [7:0] L3 = L_values[31:24];

    // Unpack the four old check-node messages
    wire signed [7:0] R_old0 = R_old_values[7:0];
    wire signed [7:0] R_old1 = R_old_values[15:8];
    wire signed [7:0] R_old2 = R_old_values[23:16];
    wire signed [7:0] R_old3 = R_old_values[31:24];

    // Datapath intermediate signals
    wire signed [7:0] Q0, Q1, Q2, Q3;

    wire signed [7:0] R_new0, R_new1, R_new2, R_new3;

    wire signed [7:0] L_new0, L_new1, L_new2, L_new3;

    // Connect the actual CNU-VNU layered datapath
    cnu_vnu_layer DATAPATH (
        .L0(L0),
        .L1(L1),
        .L2(L2),
        .L3(L3),

        .R_old0(R_old0),
        .R_old1(R_old1),
        .R_old2(R_old2),
        .R_old3(R_old3),

        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),

        .R_new0(R_new0),
        .R_new1(R_new1),
        .R_new2(R_new2),
        .R_new3(R_new3),

        .L_new0(L_new0),
        .L_new1(L_new1),
        .L_new2(L_new2),
        .L_new3(L_new3),

        .min1(min1),
        .min2(min2)
    );

    // Pack results for memory-controller write-back
    assign Q_values = {
        Q3, Q2, Q1, Q0
    };

    assign R_new_values = {
        R_new3, R_new2, R_new1, R_new0
    };

    assign L_new_values = {
        L_new3, L_new2, L_new1, L_new0
    };

endmodule
