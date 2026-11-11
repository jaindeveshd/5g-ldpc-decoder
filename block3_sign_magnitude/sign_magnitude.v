`timescale 1ns/1ps
module sign_magnitude (
    input  wire signed [7:0] L,
    output wire              sign,
    output wire [7:0]        magnitude
);

    wire [7:0] negated;

    assign sign = L[7];

    assign negated = (~L[7:0]) + 8'd1;

    assign magnitude = sign ? negated : L[7:0];

endmodule
