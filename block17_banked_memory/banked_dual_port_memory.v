
`timescale 1ns/1ps

module banked_dual_port_memory #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 15,
    parameter TOTAL_DEPTH = 26112,
    parameter BANKS = 8,
    parameter BANK_BITS = 3
)(
    input wire clk,
    input wire rst_n,

    // Global Port A
    input wire en_a,
    input wire we_a,
    input wire [ADDR_WIDTH-1:0] addr_a,
    input wire [DATA_WIDTH-1:0] din_a,
    output wire [DATA_WIDTH-1:0] dout_a,
    output wire addr_valid_a,

    // Global Port B
    input wire en_b,
    input wire we_b,
    input wire [ADDR_WIDTH-1:0] addr_b,
    input wire [DATA_WIDTH-1:0] din_b,
    output wire [DATA_WIDTH-1:0] dout_b,
    output wire addr_valid_b
);

    localparam LOCAL_ADDR_WIDTH = ADDR_WIDTH - BANK_BITS;
    localparam BANK_DEPTH =
        (TOTAL_DEPTH + BANKS - 1) / BANKS;

    wire [BANK_BITS-1:0] bank_sel_a;
    wire [BANK_BITS-1:0] bank_sel_b;

    wire [LOCAL_ADDR_WIDTH-1:0] local_addr_a;
    wire [LOCAL_ADDR_WIDTH-1:0] local_addr_b;

    wire [DATA_WIDTH-1:0] bank_dout_a [0:BANKS-1];
    wire [DATA_WIDTH-1:0] bank_dout_b [0:BANKS-1];

    reg [BANK_BITS-1:0] selected_bank_a;
    reg [BANK_BITS-1:0] selected_bank_b;

    integer i;

    // Interleaved address mapping
    assign bank_sel_a = addr_a[BANK_BITS-1:0];
    assign bank_sel_b = addr_b[BANK_BITS-1:0];

    assign local_addr_a = addr_a >> BANK_BITS;
    assign local_addr_b = addr_b >> BANK_BITS;

    // Reject addresses outside configured memory depth
    assign addr_valid_a = (addr_a < TOTAL_DEPTH);
    assign addr_valid_b = (addr_b < TOTAL_DEPTH);

    // Hold the bank selection of the most recent accepted access.
    always @(posedge clk) begin
        if (!rst_n) begin
            selected_bank_a <= {BANK_BITS{1'b0}};
            selected_bank_b <= {BANK_BITS{1'b0}};
        end else begin
            if (en_a && addr_valid_a)
                selected_bank_a <= bank_sel_a;

            if (en_b && addr_valid_b)
                selected_bank_b <= bank_sel_b;
        end
    end

    // Select the output of the most recently accessed bank.
    assign dout_a = bank_dout_a[selected_bank_a];
    assign dout_b = bank_dout_b[selected_bank_b];

    // Instantiate all physical memory banks.
    genvar g;
    generate
        for (g = 0; g < BANKS; g = g + 1) begin : BANK_ARRAY

            dual_port_ram #(
                .DATA_WIDTH(DATA_WIDTH),
                .ADDR_WIDTH(LOCAL_ADDR_WIDTH),
                .DEPTH(BANK_DEPTH)
            ) BANK_RAM (
                .clk(clk),
                .rst_n(rst_n),

                .en_a(en_a && addr_valid_a &&
                      (bank_sel_a == g)),
                .we_a(we_a),
                .addr_a(local_addr_a),
                .din_a(din_a),
                .dout_a(bank_dout_a[g]),

                .en_b(en_b && addr_valid_b &&
                      (bank_sel_b == g)),
                .we_b(we_b),
                .addr_b(local_addr_b),
                .din_b(din_b),
                .dout_b(bank_dout_b[g])
            );

        end
    endgenerate

endmodule
