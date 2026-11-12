
`timescale 1ns/1ps

module tb_ldpc_edge_gather_controller;

    parameter DATA_WIDTH = 8;
    parameter MAX_DEGREE = 19;
    parameter LLR_ADDR_WIDTH = 15;
    parameter EDGE_ADDR_WIDTH = 18;

    reg clk;
    reg rst_n;
    reg start;
    reg bg_select;
    reg [9:0] zc;

    reg edge_valid;
    reg edge_last;
    wire edge_ready;

    reg [5:0] row_index;
    reg [6:0] col_index;
    reg [8:0] shift_value;
    reg [9:0] current_edge_addr;

    wire llr_en;
    wire llr_we;
    wire [LLR_ADDR_WIDTH-1:0] llr_addr;
    wire [DATA_WIDTH-1:0] llr_din;
    reg signed [DATA_WIDTH-1:0] llr_dout;

    wire edge_en;
    wire edge_we;
    wire [EDGE_ADDR_WIDTH-1:0] edge_addr;
    wire [DATA_WIDTH-1:0] edge_din;
    reg signed [DATA_WIDTH-1:0] edge_dout;

    wire [4:0] degree;
    wire [8:0] lifted_index;

    wire [MAX_DEGREE*DATA_WIDTH-1:0] L_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] R_old_values;

    wire gathered_valid;
    reg gathered_ready;

    wire busy;
    wire layer_done;
    wire error;

    integer errors;
    integer checks;
    integer i, j;
    integer source;
    integer expected_L;
    integer expected_R;

    // Behavioral synchronous memory model
    reg [7:0] llr_mem [0:26111];
    reg [7:0] edge_mem [0:196991];

    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    ldpc_edge_gather_controller DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .zc(zc),

        .edge_valid(edge_valid),
        .edge_last(edge_last),
        .edge_ready(edge_ready),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout),

        .edge_en(edge_en),
        .edge_we(edge_we),
        .edge_addr(edge_addr),
        .edge_din(edge_din),
        .edge_dout(edge_dout),

        .degree(degree),
        .lifted_index(lifted_index),
        .L_values(L_values),
        .R_old_values(R_old_values),

        .gathered_valid(gathered_valid),
        .gathered_ready(gathered_ready),

        .busy(busy),
        .layer_done(layer_done),
        .error(error)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    initial clk = 0;
    always #5 clk = ~clk;

    // ------------------------------------------------
    // Synchronous memory read model
    // ------------------------------------------------

    always @(posedge clk) begin

        if (!rst_n) begin
            llr_dout <= 0;
            edge_dout <= 0;
        end else begin

            if (llr_en)
                llr_dout <= llr_mem[llr_addr];

            if (edge_en)
                edge_dout <= edge_mem[edge_addr];

        end
    end

    // ------------------------------------------------
    // Send one edge's metadata
    // ------------------------------------------------

    task send_edge;
        input [6:0] col;
        input [8:0] shift;
        input [9:0] edge_number;
        input last_edge;

        begin
            @(negedge clk);

            while (!edge_ready)
                @(negedge clk);

            edge_valid = 1'b1;
            edge_last = last_edge;

            row_index = 0;
            col_index = col;
            shift_value = shift;
            current_edge_addr = edge_number;

            @(negedge clk);

            edge_valid = 1'b0;
            edge_last = 1'b0;
        end
    endtask

    // ------------------------------------------------
    // Main test
    // ------------------------------------------------

    initial begin

        errors = 0;
        checks = 0;

        rst_n = 0;
        start = 0;
        bg_select = 0;
        zc = 8;

        edge_valid = 0;
        edge_last = 0;

        row_index = 0;
        col_index = 0;
        shift_value = 0;
        current_edge_addr = 0;

        gathered_ready = 0;

        llr_dout = 0;
        edge_dout = 0;

        $display("--------------------------------------");
        $display("EDGE GATHER CONTROLLER TEST");
        $display("--------------------------------------");

        // --------------------------------------------
        // Initialize memory locations used by the test
        // --------------------------------------------

        // Three columns: 1, 2, 3
        // Three edges: 0, 1, 2
        // LLR address = column * 384 + source index
        // Edge address = edge number * 384 + lifted index

        for (j = 0; j < 3; j = j + 1) begin

            for (i = 0; i < 8; i = i + 1) begin

                edge_mem[j*384+i] = j*20+i;

                source = i;

                llr_mem[(j+1)*384+source] =
                    (j+1)*10+source;

            end
        end

        // Fill shifted LLR locations as well.
        // The address generator accesses (i + shift) mod 8.

        for (j = 0; j < 3; j = j + 1) begin

            for (i = 0; i < 8; i = i + 1) begin

                source = (i+j+1) % 8;

                llr_mem[(j+1)*384+source] =
                    (j+1)*10+source;

            end
        end

        // --------------------------------------------
        // Reset
        // --------------------------------------------

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        repeat (2) @(negedge clk);

        // --------------------------------------------
        // Start controller
        // --------------------------------------------

        $display("TEST 1: Start BG1, Zc=8");

        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        // --------------------------------------------
        // Send three edges for one row
        // --------------------------------------------

        $display("TEST 2: Capture three edge entries");

        send_edge(7'd1, 9'd1, 10'd0, 1'b0);
        send_edge(7'd2, 9'd2, 10'd1, 1'b0);
        send_edge(7'd3, 9'd3, 10'd2, 1'b1);

        // --------------------------------------------
        // Check all eight lifted positions
        // --------------------------------------------

        $display("TEST 3: Verify gathered LLR and edge messages");

        for (i = 0; i < 8; i = i + 1) begin

            // Wait for gathered output.
            @(negedge clk);

            while (!gathered_valid)
                @(negedge clk);

            // Check degree and lifted index.
            checks = checks + 1;

            if (degree !== 5'd3) begin
                $display("ERROR: Incorrect degree at index %0d", i);
                errors = errors + 1;
            end

            if (lifted_index !== i) begin
                $display("ERROR: Incorrect lifted index. Expected %0d, got %0d",
                         i, lifted_index);
                errors = errors + 1;
            end

            // Check all three gathered lanes.
            for (j = 0; j < 3; j = j + 1) begin

                source = (i+j+1) % 8;

                expected_L = (j+1)*10+source;
                expected_R = j*20+i;

                checks = checks + 1;

                if (L_values[j*8 +: 8] !== expected_L[7:0]) begin
                    $display(
                        "ERROR: LLR mismatch at lifted=%0d lane=%0d expected=%0d got=%0d",
                        i, j, expected_L, L_values[j*8 +: 8]
                    );
                    errors = errors + 1;
                end

                checks = checks + 1;

                if (R_old_values[j*8 +: 8] !== expected_R[7:0]) begin
                    $display(
                        "ERROR: Edge message mismatch at lifted=%0d lane=%0d expected=%0d got=%0d",
                        i, j, expected_R, R_old_values[j*8 +: 8]
                    );
                    errors = errors + 1;
                end

            end

            $display("Checked lifted position %0d", i);

            // Accept gathered data.
            gathered_ready = 1'b1;

            @(negedge clk);

            gathered_ready = 1'b0;

        end

        // --------------------------------------------
        // Wait for completion
        // --------------------------------------------

        $display("TEST 4: Wait for row gathering completion");

        wait(layer_done == 1'b1);
        @(negedge clk);

        checks = checks + 1;

        if (error !== 1'b0) begin
            $display("ERROR: Controller error asserted");
            errors = errors + 1;
        end

        if (busy !== 1'b0) begin
            $display("ERROR: Busy did not deassert");
            errors = errors + 1;
        end

        // --------------------------------------------
        // Summary
        // --------------------------------------------

        $display("--------------------------------------");
        $display("EDGE GATHER TEST SUMMARY");
        $display("Total checks : %0d", checks);
        $display("Total errors : %0d", errors);

        if (errors == 0)
            $display("PASS: EDGE GATHER CONTROLLER");
        else
            $display("FAIL: EDGE GATHER CONTROLLER");

        $display("--------------------------------------");

        $finish;

    end

    // Timeout protection
    initial begin
        #200000;

        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule
