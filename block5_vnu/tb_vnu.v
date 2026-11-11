
`timescale 1ns/1ps

module tb_vnu;

    reg signed [7:0] L_old;
    reg signed [7:0] R_old;
    reg signed [7:0] R_new;

    wire signed [7:0] L_new;

    integer a, b, c;
    integer expected;
    integer errors;
    integer tests;

    vnu dut (
        .L_old(L_old),
        .R_old(R_old),
        .R_new(R_new),
        .L_new(L_new)
    );

    task check_case;
        input integer x;
        input integer y;
        input integer z;
        begin
            L_old = x;
            R_old = y;
            R_new = z;

            expected = x - y + z;

            if (expected > 127)
                expected = 127;
            else if (expected < -128)
                expected = -128;

            #1;
            tests = tests + 1;

            if ($signed(L_new) !== expected) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display("ERROR: L_old=%0d R_old=%0d R_new=%0d Got=%0d Expected=%0d",
                             x, y, z, $signed(L_new), expected);
            end
        end
    endtask

    initial begin
        $dumpfile("vnu.vcd");
        $dumpvars(0, tb_vnu);

        errors = 0;
        tests = 0;

        // Directed boundary and normal cases.
        check_case(20, 5, 10);
        check_case(30, 10, -5);
        check_case(100, -50, 100);
        check_case(-100, 50, -100);
        check_case(10, 10, 10);
        check_case(127, -128, 127);
        check_case(-128, 127, -128);
        check_case(0, 0, 0);
        check_case(127, 0, 1);
        check_case(-128, 0, -1);

        // Exhaustive test over a deterministic subset
        // of the input space.
        for (a = -128; a <= 127; a = a + 1) begin
            for (b = -128; b <= 127; b = b + 1) begin
                c = a + b;

			if (c > 127)
  			  c = c - 256;
				else if (c < -128)
   				 c = c + 256;
                check_case(a, b, c);
            end
        end

        $display("--------------------------------");
        $display("Total tests : %0d", tests);
        $display("Total errors: %0d", errors);
        $display("--------------------------------");

        if (errors == 0)
            $display("PASS: VNU verification successful.");
        else
            $display("FAIL: VNU verification failed.");

        $finish;
    end

endmodule


