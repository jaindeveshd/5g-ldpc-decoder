
`timescale 1ns/1ps

module ldpc_message_memory #(
    parameter DATA_WIDTH = 8,

    // Maximum BG1 dimensions: 68 columns x 384
    parameter MAX_COLUMNS = 68,
    parameter MAX_ZC = 384,

    // Combined BG1 and BG2 edge count: 316 + 197
    parameter MAX_EDGES = 513,

    parameter LLR_ADDR_WIDTH = 15,
    parameter EDGE_ADDR_WIDTH = 18
)(
    input wire clk,
    input wire rst_n,

    // ------------------------------------
    // LLR memory interface
    // ------------------------------------
    input wire llr_en,
    input wire llr_we,
    input wire [LLR_ADDR_WIDTH-1:0] llr_addr,
    input wire signed [DATA_WIDTH-1:0] llr_din,
    output reg signed [DATA_WIDTH-1:0] llr_dout,

    // ------------------------------------
    // Check-node message memory interface
    // ------------------------------------
    input wire edge_en,
    input wire edge_we,
    input wire [EDGE_ADDR_WIDTH-1:0] edge_addr,
    input wire signed [DATA_WIDTH-1:0] edge_din,
    output reg signed [DATA_WIDTH-1:0] edge_dout
);

    localparam LLR_DEPTH = MAX_COLUMNS * MAX_ZC;
    localparam EDGE_DEPTH = MAX_EDGES * MAX_ZC;

    // ------------------------------------
    // Memory arrays
    // ------------------------------------
    reg signed [DATA_WIDTH-1:0] llr_mem [0:LLR_DEPTH-1];

    reg signed [DATA_WIDTH-1:0] edge_mem [0:EDGE_DEPTH-1];

    // ------------------------------------
    // LLR memory operation
    // ------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            llr_dout <= 0;
        end
        else if (llr_en) begin

            if (llr_addr < LLR_DEPTH) begin

                if (llr_we)
                    llr_mem[llr_addr] <= llr_din;

                // Synchronous read
                // Read-first behavior
                llr_dout <= llr_mem[llr_addr];

            end
            else begin
                llr_dout <= 0;
            end
        end
    end

    // ------------------------------------
    // Check-node message memory operation
    // ------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            edge_dout <= 0;
        end
        else if (edge_en) begin

            if (edge_addr < EDGE_DEPTH) begin

                if (edge_we)
                    edge_mem[edge_addr] <= edge_din;

                // Synchronous read
                // Read-first behavior
                edge_dout <= edge_mem[edge_addr];

            end
            else begin
                edge_dout <= 0;
            end
        end
    end

endmodule
