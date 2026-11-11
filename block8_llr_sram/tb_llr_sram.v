
`timescale 1ns/1ps

module tb_llr_sram;

    reg clk;

    reg we_a, we_b;
    reg [6:0] addr_a, addr_b;
    reg [7:0] din_a, din_b;

    wire [7:0] dout_a, dout_b;

    integer i;
    integer errors;

    llr_sram DUT (
        .clk(clk),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),
        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // 10 ns clock period
    initial clk = 0;
    always #5 clk = ~clk;

    task write_both;
        input [6:0] address_a;
        input [7:0] data_a;
        input [6:0] address_b;
        input [7:0] data_b;
        begin
            @(negedge clk);
            we_a = 1;
            we_b = 1;
            addr_a = address_a;
            addr_b = address_b;
            din_a = data_a;
            din_b = data_b;

            @(posedge clk);
            #1;
        end
    endtask

    task read_both;
        input [6:0] address_a;
        input [6:0] address_b;
        input [7:0] expected_a;
        input [7:0] expected_b;
        begin
            @(negedge clk);
            we_a = 0;
            we_b = 0;
            addr_a = address_a;
            addr_b = address_b;

            @(posedge clk);
            #1;

            if (dout_a !== expected_a) begin
                $display("FAIL Port A: address=%0d expected=%h got=%h",
                         address_a, expected_a, dout_a);
                errors = errors + 1;
            end

            if (dout_b !== expected_b) begin
                $display("FAIL Port B: address=%0d expected=%h got=%h",
                         address_b, expected_b, dout_b);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("llr_sram.vcd");
        $dumpvars(0, tb_llr_sram);

        clk = 0;
        we_a = 0;
        we_b = 0;
        addr_a = 0;
        addr_b = 0;
        din_a = 0;
        din_b = 0;
        errors = 0;

        $display("--------------------------------");
        $display("LLR SRAM VERIFICATION");
        $display("--------------------------------");

        // Test 1: Write all 128 locations
        for (i = 0; i < 128; i = i + 2) begin
            write_both(i, i + 8'h20,
                       i + 1, i + 8'h40);
        end

        $display("All 128 memory locations written.");

        // Test 2: Read back all 128 locations
        for (i = 0; i < 128; i = i + 2) begin
            read_both(i, i + 1,
                      i + 8'h20, i + 8'h40);
        end

        $display("All 128 memory locations read back.");

        // Test 3: Same-address write collision
        write_both(7'd10, 8'h11,
                   7'd10, 8'h55);

        // Port B is expected to win
        read_both(7'd10, 7'd10,
                  8'h55, 8'h55);

        // Test 4: Independent access to different banks
        write_both(7'd16, 8'hA5,
                   7'd112, 8'h5A);

        read_both(7'd16, 7'd112,
                  8'hA5, 8'h5A);

        $display("--------------------------------");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: LLR SRAM VERIFIED");
        else
            $display("FAIL: CHECK RTL");

        $display("--------------------------------");

        $finish;
    end

endmodule
