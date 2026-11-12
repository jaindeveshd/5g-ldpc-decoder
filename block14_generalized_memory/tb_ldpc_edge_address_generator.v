
`timescale 1ns/1ps

module tb_ldpc_edge_address_generator;

    reg bg_select;
    reg [5:0] row_index;
    reg [6:0] col_index;
    reg [8:0] shift_value;
    reg [9:0] current_edge_addr;
    reg [9:0] zc;
    reg [8:0] lifted_index;

    wire [14:0] llr_addr;
    wire [17:0] edge_addr;
    wire [8:0] source_index;
    wire address_valid;
    wire address_error;

    integer checks;
    integer errors;

    ldpc_edge_address_generator DUT (
        .bg_select(bg_select),
        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),
        .zc(zc),
        .lifted_index(lifted_index),
        .llr_addr(llr_addr),
        .edge_addr(edge_addr),
        .source_index(source_index),
        .address_valid(address_valid),
        .address_error(address_error)
    );

    task check_valid;
        input [14:0] expected_llr;
        input [17:0] expected_edge;
        input [8:0] expected_source;
        begin
            #1;
            checks = checks + 3;

            if (address_valid !== 1'b1) begin
                $display("ERROR: Expected valid address");
                errors = errors + 1;
            end

            if (address_error !== 1'b0) begin
                $display("ERROR: Unexpected address error");
                errors = errors + 1;
            end

            if (llr_addr !== expected_llr) begin
                $display("ERROR: LLR address expected %0d, got %0d",
                         expected_llr, llr_addr);
                errors = errors + 1;
            end

            if (edge_addr !== expected_edge) begin
                $display("ERROR: Edge address expected %0d, got %0d",
                         expected_edge, edge_addr);
                errors = errors + 1;
            end

            if (source_index !== expected_source) begin
                $display("ERROR: Source index expected %0d, got %0d",
                         expected_source, source_index);
                errors = errors + 1;
            end
        end
    endtask

    task check_invalid;
        begin
            #1;
            checks = checks + 2;

            if (address_valid !== 1'b0) begin
                $display("ERROR: Invalid input accepted");
                errors = errors + 1;
            end

            if (address_error !== 1'b1) begin
                $display("ERROR: Invalid input did not assert error");
                errors = errors + 1;
            end
        end
    endtask

    initial begin

        bg_select = 0;
        row_index = 0;
        col_index = 0;
        shift_value = 0;
        current_edge_addr = 0;
        zc = 8;
        lifted_index = 0;

        checks = 0;
        errors = 0;

        $display("--------------------------------------");
        $display("LDPC EDGE ADDRESS GENERATOR TEST");
        $display("--------------------------------------");

        // TEST 1: BG1 normal address
        $display("\nTEST 1: BG1 normal address");

        bg_select = 0;
        row_index = 5;
        col_index = 10;
        current_edge_addr = 20;
        zc = 8;
        lifted_index = 2;
        shift_value = 3;

        // source = (2 + 3) mod 8 = 5
        // LLR = 10*384 + 5 = 3845
        // EDGE = 20*384 + 2 = 7682
        check_valid(3845, 7682, 5);

        // TEST 2: BG1 circular wrapping
        $display("\nTEST 2: BG1 circular wrapping");

        bg_select = 0;
        row_index = 0;
        col_index = 67;
        current_edge_addr = 315;
        zc = 384;
        lifted_index = 380;
        shift_value = 10;

        // source = (380 + 10) mod 384 = 6
        // LLR = 67*384 + 6 = 25734
        // EDGE = 315*384 + 380 = 121340
        check_valid(25734, 121340, 6);

        // TEST 3: BG2 normal address
        $display("\nTEST 3: BG2 normal address");

        bg_select = 1;
        row_index = 10;
        col_index = 20;
        current_edge_addr = 316;
        zc = 16;
        lifted_index = 12;
        shift_value = 7;

        // source = (12 + 7) mod 16 = 3
        // LLR = 20*384 + 3 = 7683
        // EDGE = 316*384 + 12 = 121356
        check_valid(7683, 121356, 3);

        // TEST 4: BG2 final edge
        $display("\nTEST 4: BG2 final edge");

        bg_select = 1;
        row_index = 41;
        col_index = 51;
        current_edge_addr = 512;
        zc = 384;
        lifted_index = 383;
        shift_value = 383;

        // source = (383 + 383) mod 384 = 382
        // LLR = 51*384 + 382 = 19966
        // EDGE = 512*384 + 383 = 196991
        check_valid(19966, 196991, 382);

        // TEST 5: Invalid lifting size
        $display("\nTEST 5: Invalid lifting size");

        bg_select = 0;
        row_index = 0;
        col_index = 0;
        current_edge_addr = 0;
        zc = 385;
        lifted_index = 0;
        shift_value = 0;

        check_invalid;

        // TEST 6: Lifted index outside Zc
        $display("\nTEST 6: Invalid lifted index");

        zc = 8;
        lifted_index = 8;
        shift_value = 0;

        check_invalid;

        // TEST 7: Shift outside Zc
        $display("\nTEST 7: Invalid shift");

        lifted_index = 0;
        shift_value = 8;

        check_invalid;

        // TEST 8: Invalid BG1 column
        $display("\nTEST 8: Invalid BG1 column");

        bg_select = 0;
        col_index = 68;
        shift_value = 0;

        check_invalid;

        // TEST 9: Invalid BG2 row
        $display("\nTEST 9: Invalid BG2 row");

        bg_select = 1;
        row_index = 42;
        col_index = 0;

        check_invalid;

        // TEST 10: Invalid global edge index
        $display("\nTEST 10: Invalid BG2 edge index");

        row_index = 0;
        current_edge_addr = 513;

        check_invalid;

        // Final report
        $display("\n--------------------------------------");
        $display("TEST SUMMARY");
        $display("--------------------------------------");

        $display("Total checks : %0d", checks);
        $display("Total errors : %0d", errors);

        if (errors == 0)
            $display("PASS: EDGE ADDRESS GENERATOR");
        else
            $display("FAIL: EDGE ADDRESS GENERATOR");

        $display("--------------------------------------");

        $finish;

    end

endmodule
