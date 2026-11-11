module tb_sat_addsub;

    reg signed [7:0] A;
    reg signed [7:0] B;
    reg              sub;

    wire signed [7:0] Y;
    wire              overflow;
    wire              cout;

    integer a;
    integer b;
    integer mode;
    integer expected;
    integer errors;
    integer tests;

    sat_addsub dut (
        .A(A),
        .B(B),
        .sub(sub),
        .Y(Y),
        .overflow(overflow),
        .cout(cout)
    );

    initial begin
        $dumpfile("sat_addsub.vcd");
        $dumpvars(0, tb_sat_addsub);

        errors = 0;
        tests  = 0;

        for (mode = 0; mode < 2; mode = mode + 1) begin
            sub = mode;

            for (a = -128; a <= 127; a = a + 1) begin
                for (b = -128; b <= 127; b = b + 1) begin

                    A = a;
                    B = b;

                    if (mode == 0)
                        expected = a + b;
                    else
                        expected = a - b;

                    if (expected > 127)
                        expected = 127;
                    else if (expected < -128)
                        expected = -128;

                    #1;
                    tests = tests + 1;

                    if ($signed(Y) !== expected) begin
                        errors = errors + 1;

                        if (errors <= 20) begin
                            $display(
                                "ERROR: A=%0d B=%0d sub=%b Y=%0d expected=%0d",
                                $signed(A), $signed(B), sub,
                                $signed(Y), expected
                            );
                        end
                    end

                    if (overflow !==
                        ((mode == 0) ?
                         ((a + b > 127) || (a + b < -128)) :
                         ((a - b > 127) || (a - b < -128)))) begin

                        errors = errors + 1;

                        if (errors <= 20) begin
                            $display(
                                "OVERFLOW ERROR: A=%0d B=%0d sub=%b overflow=%b",
                                $signed(A), $signed(B), sub, overflow
                            );
                        end
                    end

                end
            end
        end

        $display("----------------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);
        $display("----------------------------------------");

        if (errors == 0)
            $display("PASS: All saturated arithmetic tests passed.");
        else
            $display("FAIL: Saturated arithmetic verification failed.");

        $finish;
    end

endmodule

