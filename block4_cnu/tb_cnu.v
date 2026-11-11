`timescale 1ns/1ps

module tb_cnu;

    reg signed [7:0] L0, L1, L2, L3;

    wire signed [7:0] Y0, Y1, Y2, Y3;
    wire [7:0] min1, min2;

    integer tests;
    integer errors;
    integer i;
    integer seed;

    cnu dut (
        .L0(L0), .L1(L1), .L2(L2), .L3(L3),
        .Y0(Y0), .Y1(Y1), .Y2(Y2), .Y3(Y3),
        .min1(min1), .min2(min2)
    );

    // Independent reference-model variables
    integer vals [0:3];
    integer mags [0:3];
    integer expected [0:3];

    integer j, k;
    integer min_excl;
    integer sign_xor;
    integer exp_mag;

    task check_case;
        input integer a, b, c, d;
        begin
            L0 = a;
            L1 = b;
            L2 = c;
            L3 = d;

            #1;

            vals[0] = $signed(L0);
            vals[1] = $signed(L1);
            vals[2] = $signed(L2);
            vals[3] = $signed(L3);

            for (j = 0; j < 4; j = j + 1) begin
                if (vals[j] < 0)
                    mags[j] = -vals[j];
                else
                    mags[j] = vals[j];
            end

            // Calculate each expected outgoing message.
            // Exclude the corresponding input.
            for (j = 0; j < 4; j = j + 1) begin
                min_excl = 999;
                sign_xor = 0;

                for (k = 0; k < 4; k = k + 1) begin
                    if (k != j) begin
                        if (mags[k] < min_excl)
                            min_excl = mags[k];

                        sign_xor = sign_xor ^ (vals[k] < 0);
                    end
                end

                if (sign_xor != 0)
                    expected[j] = -min_excl;
                else if (min_excl > 127)
                    expected[j] = 127;
                else
                    expected[j] = min_excl;
            end

            tests = tests + 1;

            if ((Y0 !== expected[0][7:0]) ||
                (Y1 !== expected[1][7:0]) ||
                (Y2 !== expected[2][7:0]) ||
                (Y3 !== expected[3][7:0])) begin

                errors = errors + 1;

                $display("ERROR: Inputs = %0d, %0d, %0d, %0d",
                         vals[0], vals[1], vals[2], vals[3]);

                $display("Actual   : Y0=%0d Y1=%0d Y2=%0d Y3=%0d",
                         $signed(Y0), $signed(Y1),
                         $signed(Y2), $signed(Y3));

                $display("Expected : Y0=%0d Y1=%0d Y2=%0d Y3=%0d",
                         expected[0], expected[1],
                         expected[2], expected[3]);
            end
        end
    endtask

    initial begin
        $dumpfile("cnu.vcd");
        $dumpvars(0, tb_cnu);

        tests = 0;
        errors = 0;
        seed = 12345;

        // Test 1: All positive
        check_case(3, 5, 7, 9);

        // Test 2: Mixed positive and negative
        check_case(-2, 4, -6, 8);

        // Test 3: Equal minimum magnitudes
        check_case(3, -3, 5, 7);

        // Test 4: Multiple equal minima
        check_case(2, -2, 2, 6);

        // Test 5: Zero input
        check_case(0, 4, -6, 8);

        // Test 6: Most-negative signed input
        check_case(-128, 4, -6, 8);

        // Test 7: All zero
        check_case(0, 0, 0, 0);

        // Test 8: All negative
        check_case(-1, -5, -7, -9);

        // Test 9: Positive saturation corner
        check_case(-128, -128, -128, -128);

        // Test 10: Negative saturation corner
        check_case(-128, 0, 0, 0);

        // Randomized tests
        for (i = 0; i < 10000; i = i + 1) begin
            check_case(
                $random(seed) % 256,
                $random(seed) % 256,
                $random(seed) % 256,
                $random(seed) % 256
            );
        end

        $display("--------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $display("--------------------------------");
        $finish;
    end

endmodule
