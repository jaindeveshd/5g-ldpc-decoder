
`timescale 1ns/1ps

module tb_banked_dual_port_memory;

    reg clk, rst_n;

    reg en_a, we_a;
    reg [4:0] addr_a;
    reg [7:0] din_a;
    wire [7:0] dout_a;
    wire addr_valid_a;

    reg en_b, we_b;
    reg [4:0] addr_b;
    reg [7:0] din_b;
    wire [7:0] dout_b;
    wire addr_valid_b;

    integer errors;

    banked_dual_port_memory #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(5),
        .TOTAL_DEPTH(30),
        .BANKS(8),
        .BANK_BITS(3)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),

        .en_a(en_a),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),
        .addr_valid_a(addr_valid_a),

        .en_b(en_b),
        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b),
        .addr_valid_b(addr_valid_b)
    );

    always #5 clk = ~clk;

    task check;
        input [7:0] actual;
        input [7:0] expected;
        input [255:0] test_name;
        begin
            if (actual !== expected) begin
                $display("FAIL: %0s | Expected=%0d Actual=%0d",
                         test_name, expected, actual);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s", test_name);
            end
        end
    endtask

    initial begin

        clk = 0;
        rst_n = 0;
        errors = 0;

        en_a = 0; we_a = 0;
        addr_a = 0; din_a = 0;

        en_b = 0; we_b = 0;
        addr_b = 0; din_b = 0;

        // Reset
        @(posedge clk);
        #1;

        check(dout_a, 0, "Port A reset");
        check(dout_b, 0, "Port B reset");

        rst_n = 1;

        // Test 1: Simultaneous writes to different banks
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 0; din_a = 10;

        en_b = 1; we_b = 1;
        addr_b = 1; din_b = 11;

        @(posedge clk);
        #1;

        // Test 2: Read both banks
        @(negedge clk);
        we_a = 0; addr_a = 0;
        we_b = 0; addr_b = 1;

        @(posedge clk);
        #1;

        check(dout_a, 10, "Read Bank 0");
        check(dout_b, 11, "Read Bank 1");

        // Test 3: Both ports access the same bank
        @(negedge clk);
        we_a = 1; addr_a = 8; din_a = 80;
        we_b = 1; addr_b = 16; din_b = 160;

        @(posedge clk);
        #1;

        // Read both locations
        @(negedge clk);
        we_a = 0; addr_a = 8;
        we_b = 0; addr_b = 16;

        @(posedge clk);
        #1;

        check(dout_a, 80, "Port A reads Bank 0 local 1");
        check(dout_b, 160, "Port B reads Bank 0 local 2");

        // Test 4: Invalid address 31
        // Configured memory depth is 30 (valid addresses 0-29).
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 31; din_a = 99;

        en_b = 0; we_b = 0;

        #1;
        if (addr_valid_a !== 1'b0) begin
            $display("FAIL: Invalid address not rejected");
            errors = errors + 1;
        end else begin
            $display("PASS: Invalid address rejected");
        end

        @(posedge clk);
        #1;

        check(dout_a, 80, "Invalid access preserves output");

        // Verify valid memory locations were not corrupted
        @(negedge clk);
        en_a = 1; we_a = 0;
        addr_a = 8;

        @(posedge clk);
        #1;

        check(dout_a, 80, "Valid memory data preserved");

        if (errors == 0)
            $display("\nPASS: ALL EIGHT-BANK MEMORY TESTS");
        else
            $display("\nFAIL: %0d ERRORS", errors);

        $finish;
    end

endmodule
