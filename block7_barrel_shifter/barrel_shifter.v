`timescale 1ns/1ps

module barrel_shifter #(
    parameter N = 8,
    parameter DATA_WIDTH = 8,
    parameter SHIFT_WIDTH = $clog2(N)
)(
    input wire [N*DATA_WIDTH-1:0] data_in,
    input wire [SHIFT_WIDTH-1:0] shift,
    output wire [N*DATA_WIDTH-1:0] data_out
);

    // Intermediate connections between MUX stages
    wire [N*DATA_WIDTH-1:0] stage [0:SHIFT_WIDTH];

    assign stage[0] = data_in;

    genvar s, i;

    generate
        for (s = 0; s < SHIFT_WIDTH; s = s + 1) begin : SHIFT_STAGE

            for (i = 0; i < N; i = i + 1) begin : MUX

                wire [SHIFT_WIDTH-1:0] shift_amount;
                assign shift_amount = (1 << s);

                // Circular left rotation
                assign stage[s+1][i*DATA_WIDTH +: DATA_WIDTH] =
                    shift[s] ?
                    stage[s][((i + (1 << s)) % N)*DATA_WIDTH +: DATA_WIDTH] :
                    stage[s][i*DATA_WIDTH +: DATA_WIDTH];

            end
        end
    endgenerate

    assign data_out = stage[SHIFT_WIDTH];

endmodule
