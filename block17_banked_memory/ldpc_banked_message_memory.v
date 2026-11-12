
`timescale 1ns/1ps

module ldpc_banked_message_memory #(
    parameter DATA_WIDTH = 8,

    parameter LLR_DEPTH = 26112,
    parameter LLR_ADDR_WIDTH = 15,

    parameter EDGE_DEPTH = 196992,
    parameter EDGE_ADDR_WIDTH = 18,

    parameter BANKS = 8,
    parameter BANK_BITS = 3
)(
    input wire clk,
    input wire rst_n,

    // LLR memory - Port A
    input wire llr_en_a,
    input wire llr_we_a,
    input wire [LLR_ADDR_WIDTH-1:0] llr_addr_a,
    input wire [DATA_WIDTH-1:0] llr_din_a,
    output wire [DATA_WIDTH-1:0] llr_dout_a,
    output wire llr_valid_a,

    // LLR memory - Port B
    input wire llr_en_b,
    input wire llr_we_b,
    input wire [LLR_ADDR_WIDTH-1:0] llr_addr_b,
    input wire [DATA_WIDTH-1:0] llr_din_b,
    output wire [DATA_WIDTH-1:0] llr_dout_b,
    output wire llr_valid_b,

    // Edge-message memory - Port A
    input wire edge_en_a,
    input wire edge_we_a,
    input wire [EDGE_ADDR_WIDTH-1:0] edge_addr_a,
    input wire [DATA_WIDTH-1:0] edge_din_a,
    output wire [DATA_WIDTH-1:0] edge_dout_a,
    output wire edge_valid_a,

    // Edge-message memory - Port B
    input wire edge_en_b,
    input wire edge_we_b,
    input wire [EDGE_ADDR_WIDTH-1:0] edge_addr_b,
    input wire [DATA_WIDTH-1:0] edge_din_b,
    output wire [DATA_WIDTH-1:0] edge_dout_b,
    output wire edge_valid_b
);

    // Eight-bank LLR memory
    banked_dual_port_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(LLR_ADDR_WIDTH),
        .TOTAL_DEPTH(LLR_DEPTH),
        .BANKS(BANKS),
        .BANK_BITS(BANK_BITS)
    ) LLR_MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        .en_a(llr_en_a),
        .we_a(llr_we_a),
        .addr_a(llr_addr_a),
        .din_a(llr_din_a),
        .dout_a(llr_dout_a),
        .addr_valid_a(llr_valid_a),

        .en_b(llr_en_b),
        .we_b(llr_we_b),
        .addr_b(llr_addr_b),
        .din_b(llr_din_b),
        .dout_b(llr_dout_b),
        .addr_valid_b(llr_valid_b)
    );

    // Eight-bank edge-message memory
    banked_dual_port_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(EDGE_ADDR_WIDTH),
        .TOTAL_DEPTH(EDGE_DEPTH),
        .BANKS(BANKS),
        .BANK_BITS(BANK_BITS)
    ) EDGE_MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        .en_a(edge_en_a),
        .we_a(edge_we_a),
        .addr_a(edge_addr_a),
        .din_a(edge_din_a),
        .dout_a(edge_dout_a),
        .addr_valid_a(edge_valid_a),

        .en_b(edge_en_b),
        .we_b(edge_we_b),
        .addr_b(edge_addr_b),
        .din_b(edge_din_b),
        .dout_b(edge_dout_b),
        .addr_valid_b(edge_valid_b)
    );

endmodule
