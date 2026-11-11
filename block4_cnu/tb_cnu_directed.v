`timescale 1ns/1ps

module tb_cnu_directed;

    reg signed [7:0] L0, L1, L2, L3;

    wire signed [7:0] Y0, Y1, Y2, Y3;
    wire [7:0] min1, min2;

    integer tests;
    integer errors;

    cnu dut (
        .L0(L0), .L1(L1), .L2(L2), .L3(L3),
        .Y0(Y0), .Y1(Y1), .Y2(Y2), .Y3(Y3),
        .min1(min1), .min2(min2)
    );

    task check_case;
        input integer a, b, c, d;
        input integer e_min1, e_min2;
        input integer e_y0, e_y1, e_y2, e_y3;

        begin
            L0 = a;
            L1 = b;
            L2 = c;
            L3 = d;

            #1;
            tests = tests + 1;

            if ((min1 !== e_min1[7:0]) ||
                (min2 !== e_min2[7:0]) ||
                (Y0 !== e_y0[7:0]) ||
                (Y1 !== e_y1[7:0]) ||
                (Y2 !== e_y2[7:0]) ||
                (Y3 !== e_y3[7:0])) begin

                errors = errors + 1;

                $display("FAIL: Inputs = %0d, %0d, %0d, %0d",
                         a, b, c, d);

                $display("Actual: min1=%0d min2=%0d Y0=%0d Y1=%0d Y2=%0d Y3=%0d",
                         min1, min2, $signed(Y0), $signed(Y1),
                         $signed(Y2), $signed(Y3));

                $display("Expected: min1=%0d min2=%0d Y0=%0d Y1=%0d Y2=%0d Y3=%0d",
                         e_min1, e_min2, e_y0, e_y1, e_y2, e_y3);
            end
            else begin
                $display("PASS: Inputs = %0d, %0d, %0d, %0d",
                         a, b, c, d);
            end
        end
    endtask

    initial begin
        tests = 0;
        errors = 0;

        // Test 1: All positive
        check_case(  2,   5,   7,   9,
                     2, 5, 5, 2, 2, 2);

        // Test 2: Equal minimum magnitudes with mixed signs
        check_case(  2,  -2,   5,   7,
                     2, 2, -2, 2, -2, -2);

        // Test 3: Zero input
        check_case(  0,   4,  -6,   8,
                     0, 4, -4, 0, 0, 0);

        // Test 4: Most-negative signed input (-128)
        check_case(-128,   4,  -6,   8,
                     4, 6, -4, 6, -4, 4);

        // Test 5: All negative
        check_case( -3,  -5,  -7,  -9,
                     3, 5, -5, -3, -3, -3);

        $display("--------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);

        if ((errors == 0) && (tests == 5))
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $display("--------------------------------");
        $finish;
    end

endmodule
