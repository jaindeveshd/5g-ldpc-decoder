
`timescale 1ns/1ps

module tb_layered_fsm;

    reg clk, rst_n, start;
    reg [5:0] num_layers;
    reg [7:0] max_iterations;

    wire rom_en;
    wire [5:0] rom_addr;
    reg rom_valid;

    wire layer_start;
    reg layer_done;

    wire syndrome_start;
    reg syndrome_done;
    reg syndrome_pass;

    wire busy, done;
    wire [7:0] iteration_count;

    integer errors;
    integer layer_pulses;
    integer syndrome_pulses;
    integer timeout;

    // DUT
    layered_fsm DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .num_layers(num_layers),
        .max_iterations(max_iterations),

        .rom_en(rom_en),
        .rom_addr(rom_addr),
        .rom_valid(rom_valid),

        .layer_start(layer_start),
        .layer_done(layer_done),

        .syndrome_start(syndrome_start),
        .syndrome_done(syndrome_done),
        .syndrome_pass(syndrome_pass),

        .busy(busy),
        .done(done),
        .iteration_count(iteration_count)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Simulated ROM, datapath and syndrome checker
    always @(posedge clk) begin
        if (!rst_n) begin
            rom_valid     <= 0;
            layer_done    <= 0;
            syndrome_done <= 0;
        end
        else begin
            // ROM responds one clock after request
            rom_valid <= rom_en;

            // Datapath completes one clock after layer_start
            layer_done <= layer_start;

            // Syndrome checker completes one clock after start
            syndrome_done <= syndrome_start;

            if (layer_start)
                layer_pulses <= layer_pulses + 1;

            if (syndrome_start)
                syndrome_pulses <= syndrome_pulses + 1;
        end
    end

    // Reset task
    task reset_dut;
        begin
            @(negedge clk);

            rst_n = 0;
            start = 0;
            syndrome_pass = 0;

            layer_pulses = 0;
            syndrome_pulses = 0;

            repeat (2) @(negedge clk);

            rst_n = 1;

            @(negedge clk);
        end
    endtask

    // Start decoder
    task start_decoder;
        begin
            @(negedge clk);
            start = 1;

            @(negedge clk);
            start = 0;
        end
    endtask

    // Wait for decoder completion with timeout
    task wait_for_done;
        begin
            timeout = 0;

            while (done !== 1'b1 && timeout < 500) begin
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

        $dumpfile("block9_layered_fsm/layered_fsm.vcd");
        $dumpvars(0, tb_layered_fsm);

        rst_n = 0;
        start = 0;

        num_layers = 3;
        max_iterations = 1;

        rom_valid = 0;
        layer_done = 0;

        syndrome_done = 0;
        syndrome_pass = 0;

        errors = 0;
        layer_pulses = 0;
        syndrome_pulses = 0;

        // --------------------------------
        // TEST 1: Single iteration
        // --------------------------------
        $display("--------------------------------");
        $display("TEST 1: Single iteration");

        reset_dut();

        num_layers = 3;
        max_iterations = 1;

        start_decoder();
        wait_for_done();

        if (iteration_count == 1 &&
            layer_pulses == 3 &&
            syndrome_pulses == 1)
            $display("PASS: Single iteration completed");
        else begin
            $display("FAIL: Iterations=%0d Layers=%0d Syndrome checks=%0d",
                     iteration_count, layer_pulses, syndrome_pulses);
            errors = errors + 1;
        end

        // --------------------------------
        // TEST 2: Maximum iteration limit
        // --------------------------------
        $display("\nTEST 2: Maximum iteration limit");

        reset_dut();

        num_layers = 2;
        max_iterations = 2;

        start_decoder();
        wait_for_done();

        if (iteration_count == 2 &&
            layer_pulses == 4 &&
            syndrome_pulses == 2)
            $display("PASS: Two iterations completed");
        else begin
            $display("FAIL: Iterations=%0d Layers=%0d Syndrome checks=%0d",
                     iteration_count, layer_pulses, syndrome_pulses);
            errors = errors + 1;
        end

        // --------------------------------
        // TEST 3: Syndrome early termination
        // --------------------------------
        $display("\nTEST 3: Syndrome early termination");

        reset_dut();

        num_layers = 2;
        max_iterations = 5;

        start_decoder();

        // Wait until the first complete layer pass
        wait (layer_pulses == 2);

        // Simulate a successful syndrome result
        @(negedge clk);
        syndrome_pass = 1;

        wait_for_done();

        if (iteration_count == 1 &&
            layer_pulses == 2 &&
            syndrome_pulses == 1)
            $display("PASS: Early termination completed");
        else begin
            $display("FAIL: Iterations=%0d Layers=%0d Syndrome checks=%0d",
                     iteration_count, layer_pulses, syndrome_pulses);
            errors = errors + 1;
        end

        // --------------------------------
        // FINAL RESULT
        // --------------------------------
        $display("\n--------------------------------");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: LAYERED FSM VERIFIED");
        else
            $display("FAIL: CHECK FSM");

        $display("--------------------------------");

        $finish;

    end

endmodule
