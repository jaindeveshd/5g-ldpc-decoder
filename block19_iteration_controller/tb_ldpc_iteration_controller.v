
`timescale 1ns/1ps

module tb_ldpc_iteration_controller;

    reg clk;
    reg rst_n;
    reg start;
    reg bg_select;
    reg [7:0] max_iterations;

    wire [5:0] layer_index;
    wire layer_start;
    reg layer_done;
    reg layer_error;

    wire syndrome_start;
    reg syndrome_done;
    reg syndrome_pass;

    wire busy;
    wire done;
    wire decoder_success;
    wire iteration_limit_reached;
    wire error;
    wire [7:0] iteration_count;

    integer total_layers;
    integer syndrome_checks;
    integer errors;
    integer i;

    ldpc_iteration_controller DUT (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .bg_select(bg_select),
        .max_iterations(max_iterations),

        .layer_index(layer_index),
        .layer_start(layer_start),
        .layer_done(layer_done),
        .layer_error(layer_error),

        .syndrome_start(syndrome_start),
        .syndrome_done(syndrome_done),
        .syndrome_pass(syndrome_pass),

        .busy(busy),
        .done(done),
        .decoder_success(decoder_success),
        .iteration_limit_reached(iteration_limit_reached),
        .error(error),
        .iteration_count(iteration_count)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset task
    task reset_dut;
    begin
        @(negedge clk);
        rst_n = 0;
        start = 0;
        layer_done = 0;
        layer_error = 0;
        syndrome_done = 0;
        syndrome_pass = 0;

        repeat (3) @(negedge clk);
        rst_n = 1;
        @(negedge clk);
    end
    endtask

    // Generate a one-cycle start pulse
    task start_decoder;
    begin
        start = 1;
        @(negedge clk);
        start = 0;
    end
    endtask

    // Respond to one layer request
    task complete_one_layer;
    begin
        wait (layer_start == 1'b1);

        @(negedge clk);
        layer_done = 1'b1;

        @(negedge clk);
        layer_done = 1'b0;

        total_layers = total_layers + 1;
    end
    endtask

    // Respond to one syndrome request
    task respond_to_syndrome;
        input result;
    begin
        wait (syndrome_start == 1'b1);

        @(negedge clk);
        syndrome_pass = result;
        syndrome_done = 1'b1;

        @(negedge clk);
        syndrome_done = 1'b0;
        syndrome_pass = 1'b0;

        syndrome_checks = syndrome_checks + 1;
    end
    endtask

    initial begin
        rst_n = 0;
        start = 0;
        bg_select = 0;
        max_iterations = 0;
        layer_done = 0;
        layer_error = 0;
        syndrome_done = 0;
        syndrome_pass = 0;

        total_layers = 0;
        syndrome_checks = 0;
        errors = 0;

        $display("----------------------------------------");
        $display(" BLOCK 19: ITERATION CONTROLLER TEST");
        $display("----------------------------------------");

        // ------------------------------------
        // TEST 1: BG1, successful first iteration
        // ------------------------------------

        reset_dut();

        bg_select = 0;          // BG1
        max_iterations = 3;

        $display("TEST 1: BG1, 46 layers, early success");

        start_decoder();

        for (i = 0; i < 46; i = i + 1)
            complete_one_layer();

        respond_to_syndrome(1'b1);

        wait (done == 1'b1);
        @(negedge clk);

        if (total_layers == 46 &&
            syndrome_checks == 1 &&
            iteration_count == 1 &&
            decoder_success &&
            !iteration_limit_reached &&
            !error) begin
            $display("PASS: BG1 processed 46 layers and stopped successfully");
        end
        else begin
            $display("FAIL: BG1 early-success test");
            errors = errors + 1;
        end

        // ------------------------------------
        // TEST 2: BG2, maximum iteration limit
        // ------------------------------------

        reset_dut();

        total_layers = 0;
        syndrome_checks = 0;

        bg_select = 1;          // BG2
        max_iterations = 2;

        $display("TEST 2: BG2, 42 layers per iteration, limit = 2");

        start_decoder();

        // First iteration: 42 layers
        for (i = 0; i < 42; i = i + 1)
            complete_one_layer();

        // First syndrome fails
        respond_to_syndrome(1'b0);

        // Second iteration: 42 layers
        for (i = 0; i < 42; i = i + 1)
            complete_one_layer();

        // Second syndrome also fails
        respond_to_syndrome(1'b0);

        wait (done == 1'b1);
        @(negedge clk);

        if (total_layers == 84 &&
            syndrome_checks == 2 &&
            iteration_count == 2 &&
            !decoder_success &&
            iteration_limit_reached &&
            !error) begin
            $display("PASS: BG2 processed 84 layers across 2 iterations");
            $display("PASS: Decoder stopped at maximum iteration count");
        end
        else begin
            $display("FAIL: BG2 iteration-limit test");
            errors = errors + 1;
        end

        // ------------------------------------
        // Final result
        // ------------------------------------

        $display("----------------------------------------");

        if (errors == 0)
            $display("PASS: ALL BLOCK 19 TESTS");
        else
            $display("FAIL: %0d ERRORS DETECTED", errors);

        $display("----------------------------------------");

        $finish;
    end

    // Simulation timeout
    initial begin
        #2000000;
        $display("FAIL: Simulation timeout");
        $finish;
    end

endmodule
