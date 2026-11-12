
`timescale 1ns/1ps

module tb_ldpc_writeback_controller;

    reg clk, rst_n, start, bg_select;
    reg [9:0] zc;

    reg edge_valid, edge_last;
    wire edge_ready;

    reg [5:0] row_index;
    reg [6:0] col_index;
    reg [8:0] shift_value;
    reg [9:0] current_edge_addr;

    reg data_valid;
    wire data_ready;

    reg [19*8-1:0] L_new_values;
    reg [19*8-1:0] R_new_values;

    wire llr_en, llr_we;
    wire [14:0] llr_addr;
    wire [7:0] llr_din;

    wire edge_en, edge_we;
    wire [17:0] edge_addr;
    wire [7:0] edge_din;

    wire [4:0] degree;
    wire [8:0] lifted_index;
    wire busy, layer_done, error;

    reg [7:0] llr_mem [0:26111];
    reg [7:0] edge_mem [0:196991];

    integer errors, checks;
    integer i, j, source;
    integer expected_L, expected_R;
    integer address_L, address_R;

    // --------------------------------------------
    // DUT
    // --------------------------------------------

    ldpc_writeback_controller DUT (
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

        .data_valid(data_valid),
        .data_ready(data_ready),
        .L_new_values(L_new_values),
        .R_new_values(R_new_values),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),

        .edge_en(edge_en),
        .edge_we(edge_we),
        .edge_addr(edge_addr),
        .edge_din(edge_din),

        .degree(degree),
        .lifted_index(lifted_index),

        .busy(busy),
        .layer_done(layer_done),
        .error(error)
    );

    // --------------------------------------------
    // Clock
    // --------------------------------------------

    initial clk = 0;
    always #5 clk = ~clk;

    // --------------------------------------------
    // Synchronous memory write model
    // --------------------------------------------

    always @(posedge clk) begin
        if (rst_n) begin
            if (llr_en && llr_we)
                llr_mem[llr_addr] <= llr_din;

            if (edge_en && edge_we)
                edge_mem[edge_addr] <= edge_din;
        end
    end

    // --------------------------------------------
    // Send edge metadata
    // --------------------------------------------

    task send_edge;
        input [6:0] col;
        input [8:0] shift;
        input [9:0] edge_number;
        input last_edge;

        begin
            @(negedge clk);

            while (!edge_ready)
                @(negedge clk);

            edge_valid = 1;
            edge_last = last_edge;
            row_index = 0;
            col_index = col;
            shift_value = shift;
            current_edge_addr = edge_number;

            @(negedge clk);

            edge_valid = 0;
            edge_last = 0;
        end
    endtask

    // --------------------------------------------
    // Send one lifted position's updated vectors
    // --------------------------------------------

    task send_data;
        input integer lift;

        begin
            @(negedge clk);

            while (!data_ready)
                @(negedge clk);

            L_new_values = 0;
            R_new_values = 0;

            for (j = 0; j < 3; j = j + 1) begin
                L_new_values[j*8 +: 8] = 40 + lift*3 + j;
                R_new_values[j*8 +: 8] = 100 + lift*3 + j;
            end

            data_valid = 1;

            @(negedge clk);
            data_valid = 0;
        end
    endtask

    // --------------------------------------------
    // Main test
    // --------------------------------------------

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

        data_valid = 0;
        L_new_values = 0;
        R_new_values = 0;

        $display("--------------------------------------");
        $display("LDPC WRITEBACK CONTROLLER TEST");
        $display("--------------------------------------");

        // Initialize memories.
        for (i = 0; i < 26112; i = i + 1)
            llr_mem[i] = 0;

        for (i = 0; i < 196992; i = i + 1)
            edge_mem[i] = 0;

        // Reset.
        repeat (3) @(negedge clk);
        rst_n = 1;
        repeat (2) @(negedge clk);

        // Start BG1, Zc=8.
        $display("TEST 1: Start BG1, Zc=8");

        start = 1;
        @(negedge clk);
        start = 0;

        // Send three edge entries.
        $display("TEST 2: Capture three edge entries");

        send_edge(1, 1, 0, 0);
        send_edge(2, 2, 1, 0);
        send_edge(3, 3, 2, 1);

        // Process and write all eight lifted positions.
        $display("TEST 3: Write updated messages");

        for (i = 0; i < 8; i = i + 1) begin
            send_data(i);
            $display("Submitted updated vectors for lifted index %0d", i);
        end

        // Wait for completion.
        wait(layer_done == 1);
        #1;

        // Check every memory location.
        $display("TEST 4: Verify LLR and edge-memory contents");

        for (i = 0; i < 8; i = i + 1) begin

            for (j = 0; j < 3; j = j + 1) begin

                source = (i + j + 1) % 8;

                address_L = (j+1)*384 + source;
                address_R = j*384 + i;

                expected_L = 40 + i*3 + j;
                expected_R = 100 + i*3 + j;

                checks = checks + 1;

                if (llr_mem[address_L] !== expected_L[7:0]) begin
                    $display(
                        "ERROR LLR: lift=%0d lane=%0d addr=%0d expected=%0d got=%0d",
                        i, j, address_L, expected_L, llr_mem[address_L]
                    );
                    errors = errors + 1;
                end

                checks = checks + 1;

                if (edge_mem[address_R] !== expected_R[7:0]) begin
                    $display(
                        "ERROR EDGE: lift=%0d lane=%0d addr=%0d expected=%0d got=%0d",
                        i, j, address_R, expected_R, edge_mem[address_R]
                    );
                    errors = errors + 1;
                end

            end
        end

        // Check controller status.
        checks = checks + 1;

        if (error !== 0) begin
            $display("ERROR: Controller error asserted");
            errors = errors + 1;
        end

        checks = checks + 1;

        if (busy !== 0) begin
            $display("ERROR: Busy did not deassert");
            errors = errors + 1;
        end

        $display("--------------------------------------");
        $display("WRITEBACK TEST SUMMARY");
        $display("Total checks : %0d", checks);
        $display("Total errors : %0d", errors);

        if (errors == 0)
            $display("PASS: LDPC WRITEBACK CONTROLLER");
        else
            $display("FAIL: LDPC WRITEBACK CONTROLLER");

        $display("--------------------------------------");

        $finish;
    end

    // Timeout
    initial begin
        #200000;
        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule
