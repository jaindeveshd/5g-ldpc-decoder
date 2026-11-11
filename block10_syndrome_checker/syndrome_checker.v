
`timescale 1ns/1ps

module syndrome_checker #(
    parameter DATA_WIDTH = 8,
    parameter NUM_ROWS = 4,
    parameter ROW_ADDR_WIDTH = 2
)(
    input wire clk,
    input wire rst_n,

    // Decoded hard-decision bits
    input wire [DATA_WIDTH-1:0] hard_bits,

    // Parity-check row interface
    input wire row_valid,
    input wire [DATA_WIDTH-1:0] row_mask,

    // Control
    input wire start,

    // Status
    output reg busy,
    output reg done,
    output reg syndrome_pass
);

    reg [ROW_ADDR_WIDTH-1:0] row_count;
    reg syndrome_error;
    reg row_parity;

    integer i;

    // Calculate parity of selected hard-decision bits
    always @* begin
        row_parity = 1'b0;

        for (i = 0; i < DATA_WIDTH; i = i + 1)
            row_parity = row_parity ^
                         (hard_bits[i] & row_mask[i]);
    end

    // Sequential syndrome checking
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row_count     <= 0;
            syndrome_error <= 0;
            busy          <= 0;
            done          <= 0;
            syndrome_pass <= 0;
        end
        else begin
            done <= 0;

            if (start && !busy) begin
                row_count      <= 0;
                syndrome_error <= 0;
                syndrome_pass <= 0;
                busy           <= 1;
            end

            else if (busy && row_valid) begin

                if (row_parity)
                    syndrome_error <= 1;

                if (row_count == NUM_ROWS - 1) begin
                    busy <= 0;
                    done <= 1;

                    syndrome_pass <=
                        !(syndrome_error || row_parity);
                end
                else begin
                    row_count <= row_count + 1'b1;
                end

            end
        end
    end

endmodule
