`timescale 1ns/1ps

module tb_cnu_vnu_layer;

    reg signed [7:0] L0, L1, L2, L3;
    reg signed [7:0] R_old0, R_old1, R_old2, R_old3;

    wire signed [7:0] Q0, Q1, Q2, Q3;
    wire signed [7:0] R_new0, R_new1, R_new2, R_new3;
    wire signed [7:0] L_new0, L_new1, L_new2, L_new3;
    wire [7:0] min1, min2;

    integer errors = 0;
    integer tests = 0;
    integer a, b, c, d;
    integer i, j;

    integer q_exp [0:3];
    integer mag [0:3];
    integer r_exp [0:3];
    integer l_exp [0:3];

    integer m1_exp, m2_exp;
    integer min_out, sign_out;
    integer temp;

    cnu_vnu_layer dut (
        .L0(L0), .L1(L1), .L2(L2), .L3(L3),
        .R_old0(R_old0), .R_old1(R_old1),
        .R_old2(R_old2), .R_old3(R_old3),
        .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3),
        .R_new0(R_new0), .R_new1(R_new1),
        .R_new2(R_new2), .R_new3(R_new3),
        .L_new0(L_new0), .L_new1(L_new1),
        .L_new2(L_new2), .L_new3(L_new3),
        .min1(min1), .min2(min2)
    );

    function integer sat8;
        input integer value;
        begin
            if (value > 127)
                sat8 = 127;
            else if (value < -128)
                sat8 = -128;
            else
                sat8 = value;
        end
    endfunction

    function integer abs_int;
        input integer value;
        begin
            if (value < 0)
                abs_int = -value;
            else
                abs_int = value;
        end
    endfunction

    task check_case;
        input integer x0, x1, x2, x3;
        input integer old0, old1, old2, old3;

        begin
            L0 = x0; L1 = x1; L2 = x2; L3 = x3;
            R_old0 = old0; R_old1 = old1;
            R_old2 = old2; R_old3 = old3;

            #1;

            // Reference: saturated subtraction
            q_exp[0] = sat8($signed(L0) - $signed(R_old0));
            q_exp[1] = sat8($signed(L1) - $signed(R_old1));
            q_exp[2] = sat8($signed(L2) - $signed(R_old2));
            q_exp[3] = sat8($signed(L3) - $signed(R_old3));

            // Calculate magnitudes and the two global minima
            m1_exp = 255;
            m2_exp = 255;

            for (i = 0; i < 4; i = i + 1) begin
                mag[i] = abs_int(q_exp[i]);

                if (mag[i] < m1_exp) begin
                    m2_exp = m1_exp;
                    m1_exp = mag[i];
                end
                else if (mag[i] < m2_exp) begin
                    m2_exp = mag[i];
                end
            end

            // Reference: CNU outgoing messages
            for (i = 0; i < 4; i = i + 1) begin
                min_out = 255;
                sign_out = 0;

                for (j = 0; j < 4; j = j + 1) begin
                    if (j != i) begin
                        if (mag[j] < min_out)
                            min_out = mag[j];

                        if (q_exp[j] < 0)
                            sign_out = sign_out ^ 1;
                    end
                end

                if (sign_out)
                    r_exp[i] = -min_out;
                else
                    r_exp[i] = sat8(min_out);

                // Reference: saturated VNU addition
                l_exp[i] = sat8(q_exp[i] + r_exp[i]);
            end

            tests = tests + 1;

            // Check intermediate Q values
            if (($signed(Q0) !== q_exp[0]) ||
                ($signed(Q1) !== q_exp[1]) ||
                ($signed(Q2) !== q_exp[2]) ||
                ($signed(Q3) !== q_exp[3])) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display("ERROR: Q outputs incorrect");
            end

            // Check CNU messages
            if (($signed(R_new0) !== r_exp[0]) ||
                ($signed(R_new1) !== r_exp[1]) ||
                ($signed(R_new2) !== r_exp[2]) ||
                ($signed(R_new3) !== r_exp[3])) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display("ERROR: R_new outputs incorrect");
            end

            // Check updated LLRs
            if (($signed(L_new0) !== l_exp[0]) ||
                ($signed(L_new1) !== l_exp[1]) ||
                ($signed(L_new2) !== l_exp[2]) ||
                ($signed(L_new3) !== l_exp[3])) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display("ERROR: L_new outputs incorrect");
            end

            // Check minimum magnitudes
            if ((min1 !== m1_exp) || (min2 !== m2_exp)) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display("ERROR: min1/min2 incorrect");
            end
        end
    endtask

    initial begin
        $dumpfile("cnu_vnu_layer.vcd");
        $dumpvars(0, tb_cnu_vnu_layer);

        // Directed cases
        check_case(20, 30, -40, 50, 0, 0, 0, 0);
        check_case(127, -128, 100, -100, -128, 127, 0, 0);
        check_case(-128, 127, -128, 127, 127, -128, 127, -128);
        check_case(0, 0, 0, 0, 0, 0, 0, 0);
        check_case(127, 127, 127, 127, -128, -128, -128, -128);

        // Randomized tests
        for (a = 0; a < 10000; a = a + 1) begin
            check_case(
                $random, $random, $random, $random,
                $random, $random, $random, $random
            );
        end

        $display("--------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);
        $display("--------------------------------");

        if (errors == 0)
            $display("PASS: CNU-VNU integration verified.");
        else
            $display("FAIL: CNU-VNU integration verification failed.");

        $finish;
    end

endmodule
