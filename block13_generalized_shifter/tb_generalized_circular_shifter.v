
`timescale 1ns/1ps

module tb_generalized_circular_shifter;

    reg clk;
    reg rst_n;
    reg start;

    reg [9:0] zc;
    reg [8:0] shift;
    reg [15:0] base_addr;
    reg out_ready;

    wire out_valid;
    wire [8:0] out_index;
    wire [15:0] source_addr;
    wire busy;
    wire done;
    wire error;

    integer errors;
    integer checks;
    integer i;
    integer expected_addr;

    integer legal_zc [0:50];

    generalized_circular_shifter #(
        .ADDR_WIDTH(16),
        .INDEX_WIDTH(9)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .zc(zc),
        .shift(shift),
        .base_addr(base_addr),
        .out_ready(out_ready),
        .out_valid(out_valid),
        .out_index(out_index),
        .source_addr(source_addr),
        .busy(busy),
        .done(done),
        .error(error)
    );

    always #5 clk = ~clk;

    // ------------------------------------------------
    // Test every legal lifting size
    // ------------------------------------------------

    task run_case;
        input integer test_zc;
        input integer test_shift;
        input integer test_base;

        integer n;
        begin
            n = 0;

            @(negedge clk);
            zc        = test_zc;
            shift     = test_shift;
            base_addr = test_base;
            out_ready = 1'b1;
            start     = 1'b1;

            @(posedge clk);
            #1;

            if (!busy || !out_valid) begin
                $display("ERROR: operation failed to start, Zc=%0d",
                         test_zc);
                errors = errors + 1;
            end

            start = 1'b0;

            while (n < test_zc) begin
                @(negedge clk);
                #1;

                if (!out_valid) begin
                    $display("ERROR: out_valid dropped at index %0d", n);
                    errors = errors + 1;
                end
                else begin
                    expected_addr =
                        test_base + ((n + test_shift) % test_zc);

                    if (out_index !== n ||
                        source_addr !== expected_addr) begin

                        $display(
                            "ERROR: Zc=%0d shift=%0d index=%0d addr=%0d expected=%0d",
                            test_zc, test_shift,
                            out_index, source_addr, expected_addr
                        );

                        errors = errors + 1;
                    end

                    checks = checks + 1;
                end

                @(posedge clk);
                #1;
                n = n + 1;
            end

            if (!done || busy) begin
                $display("ERROR: completion failed for Zc=%0d",
                         test_zc);
                errors = errors + 1;
            end
            else begin
                checks = checks + 1;
            end
        end
    endtask

    // ------------------------------------------------
    // Invalid lifting-size test
    // ------------------------------------------------

    task test_invalid_zc;
        input integer test_zc;
        begin
            @(negedge clk);
            zc = test_zc;
            shift = 0;
            base_addr = 16'd100;
            start = 1'b1;

            @(posedge clk);
            #1;
            start = 1'b0;

            if (!error || busy) begin
                $display("ERROR: invalid Zc=%0d not rejected",
                         test_zc);
                errors = errors + 1;
            end
            else begin
                $display("PASS: invalid Zc=%0d rejected", test_zc);
                checks = checks + 1;
            end
        end
    endtask

    // ------------------------------------------------
    // Invalid shift test
    // ------------------------------------------------

    task test_invalid_shift;
        input integer test_zc;
        begin
            @(negedge clk);
            zc = test_zc;
            shift = test_zc;
            base_addr = 16'd100;
            start = 1'b1;

            @(posedge clk);
            #1;
            start = 1'b0;

            if (!error || busy) begin
                $display("ERROR: shift >= Zc not rejected");
                errors = errors + 1;
            end
            else begin
                $display("PASS: shift >= Zc rejected");
                checks = checks + 1;
            end
        end
    endtask

    // ------------------------------------------------
    // Backpressure and recovery test
    // ------------------------------------------------

    task test_backpressure;
        integer bp_index;
        integer expected_bp_addr;
        begin
            // Start with downstream stalled.
            @(negedge clk);
            zc = 10;
            shift = 7;
            base_addr = 16'd200;
            out_ready = 1'b0;
            start = 1'b1;

            @(posedge clk);
            #1;
            start = 1'b0;

            // Verify address stability during stall.
            repeat (3) begin
                @(negedge clk);
                #1;

                if (!out_valid ||
                    out_index !== 9'd0 ||
                    source_addr !== 16'd207) begin

                    $display("ERROR: backpressure stability failure");
                    errors = errors + 1;
                end
                else begin
                    checks = checks + 1;
                end
            end

            // Release backpressure.
            out_ready = 1'b1;

            // Check each address before its acceptance edge.
            for (bp_index = 0; bp_index < 10;
                 bp_index = bp_index + 1) begin

                #1;
                expected_bp_addr =
                    200 + ((bp_index + 7) % 10);

                if (!out_valid ||
                    out_index !== bp_index ||
                    source_addr !== expected_bp_addr) begin

                    $display(
                        "ERROR: backpressure recovery index=%0d actual_index=%0d actual_addr=%0d expected_addr=%0d",
                        bp_index, out_index,
                        source_addr, expected_bp_addr
                    );

                    errors = errors + 1;
                end
                else begin
                    checks = checks + 1;
                end

                // Accept current address.
                @(posedge clk);
                #1;

                // Wait for next address.
                if (bp_index < 9)
                    @(negedge clk);
            end

            // Final transaction must have completed.
            if (!done || busy) begin
                $display("ERROR: backpressure operation did not complete");
                errors = errors + 1;
            end
            else begin
                $display("PASS: backpressure and recovery");
                checks = checks + 1;
            end

            out_ready = 1'b1;
        end
    endtask

    // ------------------------------------------------
    // Main test sequence
    // ------------------------------------------------

    initial begin

        clk = 0;
        rst_n = 0;
        start = 0;
        zc = 0;
        shift = 0;
        base_addr = 0;
        out_ready = 1;

        errors = 0;
        checks = 0;

        // All 51 legal 5G NR lifting sizes.
        legal_zc[0]  = 2;
        legal_zc[1]  = 3;
        legal_zc[2]  = 4;
        legal_zc[3]  = 5;
        legal_zc[4]  = 6;
        legal_zc[5]  = 7;
        legal_zc[6]  = 8;
        legal_zc[7]  = 9;
        legal_zc[8]  = 10;
        legal_zc[9]  = 11;
        legal_zc[10] = 12;
        legal_zc[11] = 13;
        legal_zc[12] = 14;
        legal_zc[13] = 15;
        legal_zc[14] = 16;
        legal_zc[15] = 18;
        legal_zc[16] = 20;
        legal_zc[17] = 22;
        legal_zc[18] = 24;
        legal_zc[19] = 26;
        legal_zc[20] = 28;
        legal_zc[21] = 30;
        legal_zc[22] = 32;
        legal_zc[23] = 36;
        legal_zc[24] = 40;
        legal_zc[25] = 44;
        legal_zc[26] = 48;
        legal_zc[27] = 52;
        legal_zc[28] = 56;
        legal_zc[29] = 60;
        legal_zc[30] = 64;
        legal_zc[31] = 72;
        legal_zc[32] = 80;
        legal_zc[33] = 88;
        legal_zc[34] = 96;
        legal_zc[35] = 104;
        legal_zc[36] = 112;
        legal_zc[37] = 120;
        legal_zc[38] = 128;
        legal_zc[39] = 144;
        legal_zc[40] = 160;
        legal_zc[41] = 176;
        legal_zc[42] = 192;
        legal_zc[43] = 208;
        legal_zc[44] = 224;
        legal_zc[45] = 240;
        legal_zc[46] = 256;
        legal_zc[47] = 288;
        legal_zc[48] = 320;
        legal_zc[49] = 352;
        legal_zc[50] = 384;

        $display("--------------------------------------");
        $display("GENERALIZED CIRCULAR SHIFTER TEST");
        $display("--------------------------------------");

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        // Test all 51 legal lifting sizes.
        for (i = 0; i < 51; i = i + 1) begin
            $display("Testing Zc=%0d", legal_zc[i]);

            run_case(
                legal_zc[i],
                legal_zc[i] - 1,
                16'd100
            );
        end

        // Invalid configurations.
        test_invalid_zc(17);
        test_invalid_zc(385);
        test_invalid_shift(8);

        // Backpressure.
        test_backpressure();

        $display("--------------------------------------");
        $display("Total checks: %0d", checks);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: GENERALIZED CIRCULAR SHIFTER");
        else
            $display("FAIL: GENERALIZED CIRCULAR SHIFTER");

        $display("--------------------------------------");

        $finish;
    end

endmodule
