
`timescale 1ns/1ps

module tb_ldpc_layer_controller;

    reg clk;
    reg rst_n;
    reg start;

    reg [5:0] num_layers;
    reg [7:0] max_iterations;

    wire rom_en;
    wire [5:0] rom_addr;
    reg rom_valid;
    wire [6:0] rom_base_addr;

    reg [7:0] hard_bits;
    reg row_valid;
    reg [7:0] row_mask;

    wire busy;
    wire done;
    wire [7:0] iteration_count;

    wire layer_start;
    wire datapath_busy;
    wire datapath_done;

    wire syndrome_start;
    wire syndrome_busy;
    wire syndrome_done;
    wire syndrome_pass;

    wire [31:0] L_values;
    wire [31:0] R_old_values;
    wire [31:0] Q_values;
    wire [31:0] R_new_values;
    wire [31:0] L_new_values;

    wire [7:0] min1;
    wire [7:0] min2;

    integer layer_count;
    integer syndrome_count;
    integer errors;

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Synthetic layer ROM:
    // Each layer occupies 8 SRAM addresses.
    assign rom_base_addr = {rom_addr, 3'b000};

    // DUT
    ldpc_layer_controller DUT (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .num_layers(num_layers),
        .max_iterations(max_iterations),

        .rom_en(rom_en),
        .rom_addr(rom_addr),
        .rom_valid(rom_valid),
        .rom_base_addr(rom_base_addr),

        .hard_bits(hard_bits),
        .row_valid(row_valid),
        .row_mask(row_mask),

        .busy(busy),
        .done(done),
        .iteration_count(iteration_count),

        .layer_start(layer_start),
        .datapath_busy(datapath_busy),
        .datapath_done(datapath_done),

        .syndrome_start(syndrome_start),
        .syndrome_busy(syndrome_busy),
        .syndrome_done(syndrome_done),
        .syndrome_pass(syndrome_pass),

        .L_values(L_values),
        .R_old_values(R_old_values),
        .Q_values(Q_values),
        .R_new_values(R_new_values),
        .L_new_values(L_new_values),

        .min1(min1),
        .min2(min2)
    );

    // Synthetic ROM response:
    // One-cycle response after rom_en.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rom_valid <= 0;
        else
            rom_valid <= rom_en;
    end

    // Count layer and syndrome requests.
    always @(posedge clk) begin
        if (!rst_n) begin
            layer_count <= 0;
            syndrome_count <= 0;
        end
        else begin
            if (layer_start)
                layer_count <= layer_count + 1;

            if (syndrome_start)
                syndrome_count <= syndrome_count + 1;
        end
    end

    // Initialize synthetic SRAM contents.
    task initialize_memory;
        integer i;
        begin
            for (i = 0; i < 128; i = i + 1)
                DUT.DATAPATH.MEM.bank_mem[i/16][i%16] = 0;

            // Layer 0
            DUT.DATAPATH.MEM.bank_mem[0][0] = 10;
            DUT.DATAPATH.MEM.bank_mem[0][1] = 20;
            DUT.DATAPATH.MEM.bank_mem[0][2] = -30;
            DUT.DATAPATH.MEM.bank_mem[0][3] = 40;

            // Layer 1
            DUT.DATAPATH.MEM.bank_mem[0][8]  = 15;
            DUT.DATAPATH.MEM.bank_mem[0][9]  = 25;
            DUT.DATAPATH.MEM.bank_mem[0][10] = -35;
            DUT.DATAPATH.MEM.bank_mem[0][11] = 45;
        end
    endtask

    task reset_test;
        begin
            @(negedge clk);
            rst_n = 0;
            start = 0;
            num_layers = 0;
            max_iterations = 0;

            hard_bits = 0;
            row_mask = 0;
            row_valid = 1;

            layer_count = 0;
            syndrome_count = 0;

            repeat (3) @(negedge clk);

            rst_n = 1;
            initialize_memory();
        end
    endtask

    task wait_for_done;
        integer timeout;
        begin
            timeout = 0;

            while (!done && timeout < 2000) begin
                @(negedge clk);
                timeout = timeout + 1;
            end

            if (timeout >= 2000) begin
                $display("ERROR: Decoder timeout");
                errors = errors + 1;
            end
        end
    endtask

    initial begin

        rst_n = 0;
        start = 0;
        num_layers = 0;
        max_iterations = 0;

        hard_bits = 0;
        row_mask = 0;
        row_valid = 1;

        layer_count = 0;
        syndrome_count = 0;
        errors = 0;

        $dumpfile("block11_memory_controller/ldpc_layer_controller.vcd");
        $dumpvars(0, tb_ldpc_layer_controller);

        // -----------------------------------------
        // TEST 1: Syndrome early termination
        // -----------------------------------------

        $display("----------------------------------------");
        $display("TEST 1: Syndrome early termination");
        $display("----------------------------------------");

        reset_test();

        num_layers = 2;
        max_iterations = 5;

        // All parity equations pass.
        hard_bits = 8'b00000000;
        row_mask = 8'b11111111;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait_for_done();

        if (iteration_count == 1 &&
            layer_count == 2 &&
            syndrome_count == 1 &&
            syndrome_pass == 1) begin

            $display("PASS: Early termination verified");
        end
        else begin
            $display("FAIL: Early termination");
            $display("Iterations = %0d", iteration_count);
            $display("Layers = %0d", layer_count);
            $display("Syndrome checks = %0d", syndrome_count);
            $display("Syndrome pass = %b", syndrome_pass);
            errors = errors + 1;
        end

        // -----------------------------------------
        // TEST 2: Maximum iteration limit
        // -----------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("TEST 2: Maximum iteration limit");
        $display("----------------------------------------");

        reset_test();

        num_layers = 2;
        max_iterations = 2;

        // Every row has odd parity: syndrome fails.
        hard_bits = 8'b00000001;
        row_mask = 8'b00000001;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait_for_done();

        if (iteration_count == 2 &&
            layer_count == 4 &&
            syndrome_count == 2 &&
            syndrome_pass == 0) begin

            $display("PASS: Maximum iteration limit verified");
        end
        else begin
            $display("FAIL: Maximum iteration limit");
            $display("Iterations = %0d", iteration_count);
            $display("Layers = %0d", layer_count);
            $display("Syndrome checks = %0d", syndrome_count);
            $display("Syndrome pass = %b", syndrome_pass);
            errors = errors + 1;
        end

        // -----------------------------------------
        // Final result
        // -----------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BLOCK 11C CONTROL INTEGRATION VERIFIED");
        else
            $display("FAIL: BLOCK 11C INTEGRATION");

        $display("----------------------------------------");

        $finish;
    end

endmodule
