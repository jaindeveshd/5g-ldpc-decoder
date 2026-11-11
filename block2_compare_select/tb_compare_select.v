module tb_compare_select;

    reg  [7:0] A;
    reg  [7:0] B;
    wire [7:0] MIN;
    wire [7:0] MAX;

    integer a, b;
    integer errors;
    integer tests;
    integer expected_min;
    integer expected_max;

    compare_select dut (
        .A(A),
        .B(B),
        .MIN(MIN),
        .MAX(MAX)
    );

    initial begin
        $dumpfile("compare_select.vcd");
        $dumpvars(0, tb_compare_select);

        errors = 0;
        tests  = 0;

        // Exhaustively test all 8-bit unsigned input combinations.
        for (a = 0; a < 256; a = a + 1) begin
            for (b = 0; b < 256; b = b + 1) begin
                A = a;
                B = b;

                if (a <= b) begin
                    expected_min = a;
                    expected_max = b;
                end else begin
                    expected_min = b;
                    expected_max = a;
                end

                #1;
                tests = tests + 1;

                if ((MIN !== expected_min) ||
                    (MAX !== expected_max)) begin
                    errors = errors + 1;

                    if (errors <= 10) begin
                        $display(
                            "FAIL: A=%0d B=%0d MIN=%0d MAX=%0d",
                            A, B, MIN, MAX
                        );
                    end
                end
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
