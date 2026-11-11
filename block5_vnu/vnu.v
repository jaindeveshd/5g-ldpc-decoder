
`timescale 1ns/1ps

module vnu (
    input  wire signed [7:0] L_old,
    input  wire signed [7:0] R_old,
    input  wire signed [7:0] R_new,

    output reg  signed [7:0] L_new
);

    // 10-bit intermediate arithmetic prevents premature overflow.
    reg signed [9:0] intermediate;

    always @* begin

        // Layered variable-node update:
        // L_new = L_old - R_old + R_new

        intermediate =
            $signed(L_old) - $signed(R_old) + $signed(R_new);

        // Saturate to signed 8-bit range.
        if (intermediate > 10'sd127)
            L_new = 8'sd127;

        else if (intermediate < -10'sd128)
            L_new = -8'sd128;

        else
            L_new = intermediate[7:0];

    end

endmodule
