
`timescale 1ns/1ps

module tb_dual_port_ram;

    reg clk, rst_n;

    reg en_a, we_a;
    reg [7:0] addr_a, din_a;
    wire [7:0] dout_a;

    reg en_b, we_b;
    reg [7:0] addr_b, din_b;
    wire [7:0] dout_b;

    integer errors;

    dual_port_ram #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(8),
        .DEPTH(256)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),

        .en_a(en_a),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),

        .en_b(en_b),
        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
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

        // Reset output registers
        @(posedge clk);
        #1;
        check(dout_a, 0, "Port A reset");
        check(dout_b, 0, "Port B reset");

        rst_n = 1;

        // Initialize test memory locations
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 10; din_a = 7;

        @(negedge clk);
        addr_a = 20; din_a = 1;

        @(negedge clk);
        addr_a = 30; din_a = 2;

        @(negedge clk);
        addr_a = 40; din_a = 9;

        @(negedge clk);
        en_a = 0; we_a = 0;

        // 1. Port A read-first test
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 10; din_a = 55;

        @(posedge clk);
        #1;
        check(dout_a, 7, "Port A read-first during write");

        // 2. Port B independently reads address 10
        @(negedge clk);
        en_a = 0; we_a = 0;
        en_b = 1; we_b = 0;
        addr_b = 10;

        @(posedge clk);
        #1;
        check(dout_b, 55, "Port B reads Port A data");

        // 3. Both ports write different addresses
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 20; din_a = 100;

        en_b = 1; we_b = 1;
        addr_b = 30; din_b = 150;

        @(posedge clk);
        #1;
        check(dout_a, 1, "Port A independent write");
        check(dout_b, 2, "Port B independent write");

        // 4. Read both written locations
        @(negedge clk);
        we_a = 0; addr_a = 20;
        we_b = 0; addr_b = 30;

        @(posedge clk);
        #1;
        check(dout_a, 100, "Port A reads its location");
        check(dout_b, 150, "Port B reads its location");

        // 5. Disabled ports retain previous output
        @(negedge clk);
        en_a = 0;
        en_b = 0;

        @(posedge clk);
        #1;
        check(dout_a, 100, "Port A output hold");
        check(dout_b, 150, "Port B output hold");

        // 6. Same-address simultaneous writes
        // Port B has priority.
        @(negedge clk);
        en_a = 1; we_a = 1;
        addr_a = 40; din_a = 11;

        en_b = 1; we_b = 1;
        addr_b = 40; din_b = 22;

        @(posedge clk);
        #1;
        check(dout_a, 9, "Collision read-first Port A");
        check(dout_b, 9, "Collision read-first Port B");

        // Verify Port B priority
        @(negedge clk);
        we_a = 0; we_b = 0;
        addr_a = 40;
        addr_b = 40;

        @(posedge clk);
        #1;
        check(dout_a, 22, "Port B priority on collision");

        if (errors == 0)
            $display("\nPASS: ALL DUAL-PORT RAM TESTS");
        else
            $display("\nFAIL: %0d ERRORS", errors);

        $finish;
    end

endmodule
