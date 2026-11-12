
`timescale 1ns/1ps

module tb_ldpc_config_layer;

    reg clk;
    reg rst_n;
    reg start;
    reg bg_select;
    reg [5:0] layer_index;
    reg [9:0] zc;
    reg edge_ready;

    wire cfg_valid;
    wire [2:0] i_ls;

    wire edge_valid;
    wire edge_last;
    wire layer_done;
    wire busy;
    wire start_error;

    wire [5:0] row_index;
    wire [6:0] col_index;
    wire [8:0] shift_value;
    wire [9:0] current_edge_addr;

    integer errors = 0;
    integer checks = 0;

    always #5 clk = ~clk;

    ldpc_config_layer DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .layer_index(layer_index),
        .zc(zc),
        .edge_ready(edge_ready),

        .cfg_valid(cfg_valid),
        .i_ls(i_ls),

        .edge_valid(edge_valid),
        .edge_last(edge_last),
        .layer_done(layer_done),
        .busy(busy),
        .start_error(start_error),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr)
    );

    // ------------------------------------------------
    // Reset task
    // ------------------------------------------------
    task reset_dut;
        begin
            @(negedge clk);
            rst_n = 0;
            start = 0;
            edge_ready = 0;

            repeat (3) @(negedge clk);

            rst_n = 1;
            @(negedge clk);
        end
    endtask

    // ------------------------------------------------
    // Start a layer with a selected configuration
    // ------------------------------------------------
    task start_layer;
        input bg;
        input [5:0] layer;
        input [9:0] z;
        input [2:0] expected_ils;

        begin
            @(negedge clk);

            bg_select = bg;
            layer_index = layer;
            zc = z;
            start = 1;
            edge_ready = 0;

            #1;
            checks = checks + 1;

            if (cfg_valid !== 1'b1 || i_ls !== expected_ils) begin
                $display("ERROR: Configuration decode failed");
                $display("Zc=%0d expected iLS=%0d got iLS=%0d valid=%b",
                    z, expected_ils, i_ls, cfg_valid);
                errors = errors + 1;
            end

            @(posedge clk);
            #1;

            if (busy !== 1'b1 || edge_valid !== 1'b1 ||
                start_error !== 1'b0) begin
                $display("ERROR: Layer failed to start");
                errors = errors + 1;
            end

            @(negedge clk);
            start = 0;
        end
    endtask

    // ------------------------------------------------
    // Check current edge while edge_ready is low
    // ------------------------------------------------
    task check_current_edge;
        input [9:0] expected_addr;
        input [5:0] expected_row;
        input [6:0] expected_col;
        input [8:0] expected_shift;

        begin
            #1;
            checks = checks + 1;

            if (edge_valid !== 1'b1 ||
                current_edge_addr !== expected_addr ||
                row_index !== expected_row ||
                col_index !== expected_col ||
                shift_value !== expected_shift ||
                edge_last !== 1'b0) begin

                $display("ERROR: Edge mismatch");
                $display("Expected addr=%0d row=%0d col=%0d shift=%0d",
                    expected_addr, expected_row,
                    expected_col, expected_shift);

                $display("Received addr=%0d row=%0d col=%0d shift=%0d last=%b",
                    current_edge_addr, row_index,
                    col_index, shift_value, edge_last);

                errors = errors + 1;
            end
        end
    endtask

    // ------------------------------------------------
    // Accept current edge and check next address
    // ------------------------------------------------
    task accept_edge;
        input [9:0] expected_next_addr;

        begin
            @(negedge clk);
            edge_ready = 1;

            @(posedge clk);
            #1;

            checks = checks + 1;

            if (busy !== 1'b1 ||
                current_edge_addr !== expected_next_addr) begin

                $display("ERROR: Edge advancement failed");
                $display("Expected next address=%0d got=%0d busy=%b",
                    expected_next_addr, current_edge_addr, busy);

                errors = errors + 1;
            end

            @(negedge clk);
            edge_ready = 0;
        end
    endtask

    // ------------------------------------------------
    // Test invalid configuration
    // ------------------------------------------------
    task check_invalid_zc;
        input [9:0] invalid_z;

        begin
            @(negedge clk);

            bg_select = 0;
            layer_index = 0;
            zc = invalid_z;
            start = 1;
            edge_ready = 0;

            @(posedge clk);
            #1;

            checks = checks + 1;

            if (cfg_valid !== 1'b0 ||
                start_error !== 1'b1 ||
                busy !== 1'b0 ||
                edge_valid !== 1'b0) begin

                $display("ERROR: Invalid Zc=%0d was not rejected",
                    invalid_z);

                errors = errors + 1;
            end
            else begin
                $display("PASS: Invalid Zc=%0d rejected", invalid_z);
            end

            @(negedge clk);
            start = 0;
        end
    endtask

    // ------------------------------------------------
    // Test invalid layer index
    // ------------------------------------------------
    task check_invalid_layer;
        input bg;
        input [5:0] invalid_layer;

        begin
            @(negedge clk);

            bg_select = bg;
            layer_index = invalid_layer;
            zc = 8;
            start = 1;
            edge_ready = 0;

            @(posedge clk);
            #1;

            checks = checks + 1;

            if (start_error !== 1'b1 || busy !== 1'b0) begin
                $display("ERROR: Invalid layer was not rejected");
                errors = errors + 1;
            end
            else begin
                $display("PASS: Invalid BG=%0d layer=%0d rejected",
                    bg, invalid_layer);
            end

            @(negedge clk);
            start = 0;
        end
    endtask

    // =================================================
    // MAIN TEST
    // =================================================
    initial begin

        clk = 0;
        rst_n = 0;
        start = 0;
        bg_select = 0;
        layer_index = 0;
        zc = 8;
        edge_ready = 0;

        $display("");
        $display("======================================");
        $display("CONFIGURATION INTEGRATION TEST");
        $display("======================================");

        reset_dut();

        // --------------------------------------------
        // TEST 1: BG1, Zc=8, iLS=0
        // --------------------------------------------
        $display("");
        $display("TEST 1: BG1 configuration");

        start_layer(1'b0, 6'd0, 10'd8, 3'd0);

        // BG1 row 0, column 0:
        // coefficient = 250
        // shift = 250 % 8 = 2
        check_current_edge(10'd0, 6'd0, 7'd0, 9'd2);

        // Hold edge_ready low and verify edge stability.
        repeat (2) begin
            @(negedge clk);
            check_current_edge(10'd0, 6'd0, 7'd0, 9'd2);
        end

        // Accept first edge.
        accept_edge(10'd1);

        // BG1 row 0, column 1:
        // coefficient = 69
        // shift = 69 % 8 = 5
        check_current_edge(10'd1, 6'd0, 7'd1, 9'd5);

        $display("PASS: BG1 configuration and edge progression");

        // --------------------------------------------
        // TEST 2: BG2, Zc=3, iLS=1
        // --------------------------------------------
        reset_dut();

        $display("");
        $display("TEST 2: BG2 configuration");

        start_layer(1'b1, 6'd0, 10'd3, 3'd1);

        // BG2 row 0, column 0:
        // coefficient = 174
        // shift = 174 % 3 = 0
        check_current_edge(10'd316, 6'd0, 7'd0, 9'd0);

        accept_edge(10'd317);

        // BG2 row 0, column 1:
        // coefficient = 97
        // shift = 97 % 3 = 1
        check_current_edge(10'd317, 6'd0, 7'd1, 9'd1);

        $display("PASS: BG2 configuration and edge progression");

        // --------------------------------------------
        // TEST 3: Invalid lifting sizes
        // --------------------------------------------
        reset_dut();

        $display("");
        $display("TEST 3: Invalid Zc rejection");

        check_invalid_zc(10'd1);
        check_invalid_zc(10'd385);

        // --------------------------------------------
        // TEST 4: Invalid layer indices
        // --------------------------------------------
        reset_dut();

        $display("");
        $display("TEST 4: Invalid layer rejection");

        check_invalid_layer(1'b0, 6'd46);
        reset_dut();

        check_invalid_layer(1'b1, 6'd42);

        // --------------------------------------------
        // FINAL SUMMARY
        // --------------------------------------------
        $display("");
        $display("======================================");
        $display("Checks performed: %0d", checks);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: CONFIGURATION INTEGRATION VERIFIED");
        else
            $display("FAIL: CONFIGURATION INTEGRATION");

        $display("======================================");

        $finish;
    end

endmodule

