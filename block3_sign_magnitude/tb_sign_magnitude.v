`timescale 1ns/1ps

module tb_sign_magnitude;

    reg signed [7:0] L;
    wire sign;
    wire [7:0] magnitude;

    integer i;
    integer expected_mag;
    integer tests;
    integer errors;

    sign_magnitude dut (
        .L(L),
        .sign(sign),
        .magnitude(magnitude)
    );

    initial begin
        $dumpfile("sign_magnitude.vcd");
        $dumpvars(0, tb_sign_magnitude);

        tests = 0;
        errors = 0;
        L = 0;

        for (i = -128; i <= 127; i = i + 1) begin
            L = i;
            expected_mag = (i < 0) ? -i : i;

            #1;
            tests = tests + 1;

            if ((sign !== (i < 0)) ||
                (magnitude !== expected_mag[7:0])) begin

                errors = errors + 1;

                $display(
                    "ERROR: L=%0d sign=%b magnitude=%0d expected_sign=%b expected_mag=%0d",
                    i, sign, magnitude, (i < 0), expected_mag
                );
            end
        end

        $display("------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $display("------------------------------");
        $finish;
    end

endmodule
