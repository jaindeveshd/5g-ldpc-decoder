
`timescale 1ns/1ps

module llr_sram #(
    parameter DATA_WIDTH = 8,
    parameter BANKS = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 7
)(
    input wire clk,

    // Port A
    input wire                  we_a,
    input wire [ADDR_WIDTH-1:0] addr_a,
    input wire [DATA_WIDTH-1:0] din_a,
    output reg [DATA_WIDTH-1:0] dout_a,

    // Port B
    input wire                  we_b,
    input wire [ADDR_WIDTH-1:0] addr_b,
    input wire [DATA_WIDTH-1:0] din_b,
    output reg [DATA_WIDTH-1:0] dout_b
);

    // Eight independent banks, each with sixteen locations
    reg [DATA_WIDTH-1:0] bank_mem [0:BANKS-1][0:DEPTH-1];

    // Address decoding
    wire [2:0] bank_a;
    wire [3:0] local_a;
    wire [2:0] bank_b;
    wire [3:0] local_b;

    assign bank_a  = addr_a[6:4];
    assign local_a = addr_a[3:0];

    assign bank_b  = addr_b[6:4];
    assign local_b = addr_b[3:0];

    // Dual-port synchronous memory access
    always @(posedge clk) begin

        // Port A write
        if (we_a)
            bank_mem[bank_a][local_a] <= din_a;

        // Port B write
        if (we_b)
            bank_mem[bank_b][local_b] <= din_b;

        // Registered reads
        dout_a <= bank_mem[bank_a][local_a];
        dout_b <= bank_mem[bank_b][local_b];

    end

endmodule
