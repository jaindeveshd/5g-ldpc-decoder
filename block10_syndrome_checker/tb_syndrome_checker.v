
`timescale 1ns/1ps

module tb_syndrome_checker;

    reg clk;
    reg rst_n;
    reg start;

    reg [7:0] hard_bits;
    reg row_valid;
    reg [7:0] row_mask;

    wire busy;
    wire done;
    wire syndrome_pass;

    integer errors;
    integer timeout;

    syndrome_checker #(
        .DATA_WIDTH(8),
        .NUM_ROWS(4),
        .ROW_ADDR_WIDTH(2)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .hard_bits(hard_bits),
        .row_valid(row_valid),
        .row_mask(row_mask),
        .start(start),
        .busy(busy),
        .done(done),
        .syndrome_pass(syndrome_pass)
    );

    // 10 ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset
    task reset_dut;
        begin
            @(negedge clk);
            rst_n = 0;
            start = 0;
            row_valid = 0;
            row_mask = 0;
            hard_bits = 0;

            repeat (2) @(negedge clk);

            rst_n = 1;
            @(negedge clk);
        end
    endtask

    // Start syndrome checker
    task start_checker;
        begin
            @(negedge clk);
            start = 1;

            @(negedge clk);
            start = 0;
        end
    endtask

    // Send one valid parity-check row
    task send_row;
        input [7:0] mask;

        begin
            @(negedge clk);
            row_mask = mask;
            row_valid = 1;

            @(negedge clk);
            row_valid = 0;
        end
    endtask

    // Wait for completion
    task wait_for_done;
        begin
            timeout = 0;

            while (done !== 1'b1 && timeout < 50) begin
                @(negedge clk);
                timeout = timeout + 1;
            end

            if (done !== 1'b1) begin
                $display("FAIL: Timeout waiting for done");
                errors = errors + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("syndrome_checker.vcd");
        $dumpvars(0, tb_syndrome_checker);

        rst_n = 0;
        start = 0;
        row_valid = 0;
        hard_bits = 0;
        row_mask = 0;
        errors = 0;
        timeout = 0;

        // =====================================
        // TEST 1: All parity checks pass
        // =====================================

        $display("--------------------------------");
        $display("TEST 1: All parity checks pass");

        reset_dut();

        hard_bits = 8'b00000101;

        start_checker();

        send_row(8'b00000111); // 1 XOR 0 XOR 1 = 0
        send_row(8'b00000101); // 1 XOR 1 = 0
        send_row(8'b00000101); // 1 XOR 1 = 0
        send_row(8'b00000000); // No selected bits = 0

        wait_for_done();

        if (syndrome_pass === 1'b1 &&
            busy === 1'b0 &&
            done === 1'b1) begin
            $display("PASS: All parity checks passed");
        end
        else begin
            $display("FAIL: Expected syndrome_pass=1");
            errors = errors + 1;
        end

        // =====================================
        // TEST 2: One parity check fails
        // =====================================

        $display("TEST 2: One parity check fails");

        reset_dut();

        hard_bits = 8'b00000001;

        start_checker();

        send_row(8'b00000001); // Parity = 1 (FAIL)
        send_row(8'b00000011); // Parity = 1 (FAIL)
        send_row(8'b00000000); // Parity = 0
        send_row(8'b00000000); // Parity = 0

        wait_for_done();

        if (syndrome_pass === 1'b0)
            $display("PASS: Parity failure detected");
        else begin
            $display("FAIL: Expected syndrome_pass=0");
            errors = errors + 1;
        end

        // =====================================
        // TEST 3: Multiple parity checks fail
        // =====================================

        $display("TEST 3: Multiple parity checks fail");

        reset_dut();

        hard_bits = 8'b00000111;

        start_checker();

        send_row(8'b00000001); // Parity = 1
        send_row(8'b00000010); // Parity = 1
        send_row(8'b00000100); // Parity = 1
        send_row(8'b00000111); // Parity = 1

        wait_for_done();

        if (syndrome_pass === 1'b0)
            $display("PASS: Multiple parity failures detected");
        else begin
            $display("FAIL: Expected syndrome_pass=0");
            errors = errors + 1;
        end

        // =====================================
        // TEST 4: Row-valid handshake
        // =====================================

        $display("TEST 4: Row-valid handshake");

        reset_dut();

        hard_bits = 8'b00000000;

        start_checker();

        // No valid rows are supplied yet
        repeat (5) @(negedge clk);

        if (busy === 1'b1 && done === 1'b0)
            $display("PASS: Checker waits for valid rows");
        else begin
            $display("FAIL: Unexpected checker behaviour");
            errors = errors + 1;
        end

        // Now supply all four valid rows
        send_row(8'b00000001);
        send_row(8'b00000010);
        send_row(8'b00000100);
        send_row(8'b00001000);

        wait_for_done();

        if (syndrome_pass === 1'b1)
            $display("PASS: Checker completed after valid rows");
        else begin
            $display("FAIL: Expected syndrome_pass=1");
            errors = errors + 1;
        end

        // =====================================
        // FINAL RESULT
        // =====================================

        $display("--------------------------------");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: SYNDROME CHECKER VERIFIED");
        else
            $display("FAIL: CHECK RTL");

        $display("--------------------------------");

        $finish;

    end

endmodule
