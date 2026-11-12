
`timescale 1ns/1ps

module dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12,
    parameter DEPTH = 4096
)(
    input wire clk,
    input wire rst_n,

    // Port A
    input wire en_a,
    input wire we_a,
    input wire [ADDR_WIDTH-1:0] addr_a,
    input wire [DATA_WIDTH-1:0] din_a,
    output reg [DATA_WIDTH-1:0] dout_a,

    // Port B
    input wire en_b,
    input wire we_b,
    input wire [ADDR_WIDTH-1:0] addr_b,
    input wire [DATA_WIDTH-1:0] din_b,
    output reg [DATA_WIDTH-1:0] dout_b
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (!rst_n) begin
            dout_a <= {DATA_WIDTH{1'b0}};
            dout_b <= {DATA_WIDTH{1'b0}};
        end else begin

            // Port A
            if (en_a) begin
                dout_a <= mem[addr_a];

                if (we_a)
                    mem[addr_a] <= din_a;
            end

            // Port B
            if (en_b) begin
                dout_b <= mem[addr_b];

                if (we_b)
                    mem[addr_b] <= din_b;
            end
        end
    end

endmodule
