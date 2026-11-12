
`timescale 1ns/1ps

module tb_ldpc_full_decoder_19d;

    reg clk;
    reg rst_n;

    reg start;
    reg bg_select;
    reg [9:0] zc;
    reg [7:0] max_iterations;

    reg [7:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire s_axis_tready;
    reg s_axis_tlast;

    wire load_done;
    wire clear_done;
    wire memory_ready;
    wire loader_error;
    wire [14:0] loaded_count;

    wire busy;
    wire done;
    wire decoder_success;
    wire iteration_limit_reached;
    wire error;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire [5:0] layer_index;
    wire [7:0] iteration_count;

    wire layer_busy;
    wire layer_done;
    wire syndrome_busy;
    wire syndrome_pass;

    integer layer_count;
    integer errors;
    integer scenario_count;

    ldpc_full_decoder_system DUT (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .bg_select(bg_select),
        .zc(zc),
        .max_iterations(max_iterations),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .load_done(load_done),
        .clear_done(clear_done),
        .memory_ready(memory_ready),
        .loader_error(loader_error),
        .loaded_count(loaded_count),

        .busy(busy),
        .done(done),
        .decoder_success(decoder_success),
        .iteration_limit_reached(iteration_limit_reached),
        .error(error),

        .cfg_valid(cfg_valid),
        .i_ls(i_ls),
        .layer_index(layer_index),
        .iteration_count(iteration_count),

        .layer_busy(layer_busy),
        .layer_done(layer_done),
        .syndrome_busy(syndrome_busy),
        .syndrome_pass(syndrome_pass),
.llr_readback_en(1'b0),
.llr_readback_addr(15'd0),
.llr_readback_data()
    );

    // 100 MHz clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Count completed layers
    always @(posedge clk) begin
        if (!rst_n)
            layer_count <= 0;
        else if (layer_done)
            layer_count <= layer_count + 1;
    end

    // Generate nonzero signed LLR patterns.
    // mode 0: positive
    // mode 1: negative
    // mode 2: alternating mixed signs

    function [7:0] make_llr;
        input integer index;
        input integer mode;

        integer magnitude;

        begin
            magnitude = 5 + (index % 11);

            case (mode)
                0: make_llr = magnitude;
                1: make_llr = -magnitude;

                2: begin
                    if ((index % 2) == 0)
                        make_llr = magnitude;
                    else
                        make_llr = -magnitude;
                end

                default: make_llr = 8'd0;
            endcase
        end
    endfunction

    // Send one AXI4-Stream transfer
    task send_beat;
        input [7:0] data;
        input last;

        begin
            @(negedge clk);

            s_axis_tdata  = data;
            s_axis_tlast  = last;
            s_axis_tvalid = 1'b1;

            while (s_axis_tready !== 1'b1)
                @(negedge clk);

            @(posedge clk);
            @(negedge clk);

            s_axis_tvalid = 1'b0;
            s_axis_tlast  = 1'b0;
        end
    endtask

    // ------------------------------------------------
    // One complete decoder verification scenario
    // ------------------------------------------------

    task run_scenario;

        input bg;
        input integer mode;
        input integer expected_count;
        input integer expected_layers;
        input integer scenario_id;

        integer i;
        integer timeout_count;
        integer scenario_errors;

        reg [7:0] sample;

        begin

            scenario_errors = 0;

            $display("");
            $display("----------------------------------------");
            $display("BLOCK 19D SCENARIO %0d", scenario_id);

            if (bg == 1'b0)
                $display("Base Graph: BG1");
            else
                $display("Base Graph: BG2");

            case (mode)
                0: $display("LLR Pattern: Positive nonzero");
                1: $display("LLR Pattern: Negative nonzero");
                2: $display("LLR Pattern: Mixed positive/negative");
            endcase

            // Reset DUT between scenarios
            @(negedge clk);

            rst_n = 1'b0;

            start = 1'b0;
            s_axis_tvalid = 1'b0;
            s_axis_tlast = 1'b0;
            s_axis_tdata = 8'd0;

            bg_select = bg;
            zc = 10'd2;
            max_iterations = 8'd1;

            repeat (5) @(posedge clk);

            @(negedge clk);
            rst_n = 1'b1;

            // Configuration check
            @(posedge clk);
            #1;

            if (cfg_valid !== 1'b1) begin
                $display("FAIL: Invalid configuration");
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: Configuration valid");
            end

            // Start loader
            @(negedge clk);
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            // Load complete LLR vector
            $display("Loading %0d LLR values...",
                     expected_count);

            for (i = 0; i < expected_count; i = i + 1) begin

                sample = make_llr(i, mode);

                send_beat(
                    sample,
                    (i == expected_count - 1)
                );

            end

            // Wait for memory initialization
            timeout_count = 0;

            while (memory_ready !== 1'b1 &&
                   timeout_count < 200000) begin

                @(posedge clk);
                timeout_count = timeout_count + 1;

            end

            #1;

            if (memory_ready !== 1'b1) begin
                $display("FAIL: Memory initialization timeout");
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: LLR loading and edge clearing");
            end

            if (loaded_count !== expected_count) begin
                $display("FAIL: Expected %0d LLRs, received %0d",
                         expected_count, loaded_count);
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: Loaded count = %0d",
                         loaded_count);
            end

            if (loader_error !== 1'b0) begin
                $display("FAIL: Loader error");
                scenario_errors = scenario_errors + 1;
            end

            // Wait for decoder completion
            $display("Waiting for complete decoding...");

            timeout_count = 0;

            while (done !== 1'b1 &&
                   timeout_count < 500000) begin

                @(posedge clk);
                timeout_count = timeout_count + 1;

            end

            #1;

            if (done !== 1'b1) begin
                $display("FAIL: Decoder completion timeout");
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: Decoder completed in %0d cycles",
                         timeout_count);
            end

            // Layer traversal
            if (layer_count != expected_layers) begin
                $display("FAIL: Expected %0d layers, got %0d",
                         expected_layers, layer_count);
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: All %0d layers processed",
                         layer_count);
            end

            // Iteration count
            if (iteration_count !== 8'd1) begin
                $display("FAIL: Expected one iteration, got %0d",
                         iteration_count);
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: Iteration count = 1");
            end

            // Syndrome result must be a known binary value.
            // Arbitrary negative/mixed patterns are not
            // assumed to represent valid LDPC codewords.

            if ((syndrome_pass !== 1'b0) &&
                (syndrome_pass !== 1'b1)) begin

                $display("FAIL: Syndrome result is unknown");
                scenario_errors = scenario_errors + 1;

            end
            else if (syndrome_pass == 1'b1) begin

                $display("Syndrome result: PASS");
                $display("Decoder success: %0b",
                         decoder_success);

            end
            else begin

                $display("Syndrome result: FAIL");
                $display("Decoder success: %0b",
                         decoder_success);
                $display("NOTE: Non-convergence is not automatically a hardware error.");

            end

            // Hardware error checks
            if (error !== 1'b0) begin
                $display("FAIL: Top-level error asserted");
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: No top-level hardware error");
            end

            if (loader_error !== 1'b0) begin
                $display("FAIL: Loader error asserted");
                scenario_errors = scenario_errors + 1;
            end

            // Decoder should be idle after completion
            if (busy !== 1'b0) begin
                $display("FAIL: Decoder remains busy");
                scenario_errors = scenario_errors + 1;
            end
            else begin
                $display("PASS: Decoder returned to idle");
            end

            if (scenario_errors == 0) begin
                $display("SCENARIO %0d: PASS", scenario_id);
            end
            else begin
                $display("SCENARIO %0d: FAIL (%0d errors)",
                         scenario_id, scenario_errors);
            end

            errors = errors + scenario_errors;
            scenario_count = scenario_count + 1;

            $display("----------------------------------------");

        end
    endtask

    // ------------------------------------------------
    // Main regression
    // ------------------------------------------------

    initial begin

        $display("");
        $display("========================================");
        $display(" BLOCK 19D INTEGRATED SIGNED LLR TEST");
        $display("========================================");

        rst_n = 1'b0;

        start = 1'b0;
        bg_select = 1'b0;
        zc = 10'd2;
        max_iterations = 8'd1;

        s_axis_tdata = 8'd0;
        s_axis_tvalid = 1'b0;
        s_axis_tlast = 1'b0;

        layer_count = 0;
        errors = 0;
        scenario_count = 0;

        // BG1: 68 columns x Zc=2 = 136 LLRs
        run_scenario(1'b0, 0, 136, 46, 1);
        run_scenario(1'b0, 1, 136, 46, 2);
        run_scenario(1'b0, 2, 136, 46, 3);

        // BG2: 52 columns x Zc=2 = 104 LLRs
        run_scenario(1'b1, 0, 104, 42, 4);
        run_scenario(1'b1, 2, 104, 42, 5);

        $display("");
        $display("========================================");
        $display(" BLOCK 19D FINAL REGRESSION SUMMARY");
        $display("========================================");

        $display("Total scenarios: %0d", scenario_count);
        $display("Total errors:    %0d", errors);

        if (errors == 0)
            $display("PASS: ALL BLOCK 19D STRUCTURAL TESTS");
        else
            $display("FAIL: BLOCK 19D (%0d ERRORS)", errors);

        $display("========================================");

        $finish;

    end

endmodule
