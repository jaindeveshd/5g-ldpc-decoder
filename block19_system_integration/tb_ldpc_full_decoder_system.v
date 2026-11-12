
`timescale 1ns/1ps

module tb_ldpc_full_decoder_system;

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

    integer i;
    integer layer_count;
    integer cycle_count;
    integer errors;

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

    // Clock: 100 MHz
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

    // Send one AXI transfer
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

    initial begin
        $display("");
        $display("========================================");
        $display(" BLOCK 19C FULL DECODER INTEGRATION TEST");
        $display("========================================");

        rst_n = 0;

        start = 0;
        bg_select = 0;
        zc = 10'd2;
        max_iterations = 8'd1;

        s_axis_tdata = 0;
        s_axis_tvalid = 0;
        s_axis_tlast = 0;

        layer_count = 0;
        cycle_count = 0;
        errors = 0;

        repeat (5) @(posedge clk);

        @(negedge clk);
        rst_n = 1;

        // Configuration check
        if (cfg_valid !== 1'b1) begin
            $display("FAIL: Invalid BG1 Zc=2 configuration");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 Zc=2 configuration valid");
        end

        // Start loading
        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        // BG1 = 68 columns x Zc=2 = 136 LLRs
        $display("Loading 136 zero-valued LLRs...");

        for (i = 0; i < 136; i = i + 1) begin
            send_beat(8'h00, (i == 135));
        end

        // Wait for loading and edge clearing
        cycle_count = 0;

        while (memory_ready !== 1'b1 &&
               cycle_count < 10000) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end

        if (memory_ready !== 1'b1) begin
            $display("FAIL: Memory initialization timeout");
            errors = errors + 1;
        end
        else begin
            $display("PASS: LLR loading and edge clearing complete");
            $display("Loaded count = %0d", loaded_count);
        end

        if (loader_error) begin
            $display("FAIL: Loader reported an error");
            errors = errors + 1;
        end

        // Wait for complete decoding
        $display("Waiting for layer processing and syndrome...");

        cycle_count = 0;

        while (done !== 1'b1 &&
               cycle_count < 500000) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end

        #1;

        if (done !== 1'b1) begin
            $display("FAIL: Decoder completion timeout");
            errors = errors + 1;
        end
        else begin
            $display("Decoder completed in %0d cycles",
                     cycle_count);
        end

        // Verify results
        if (decoder_success !== 1'b1) begin
            $display("FAIL: Decoder did not report success");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Decoder success");
        end

        if (syndrome_pass !== 1'b1) begin
            $display("FAIL: Syndrome did not pass");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Syndrome check passed");
        end

        if (layer_count != 46) begin
            $display("FAIL: Expected 46 layers, got %0d",
                     layer_count);
            errors = errors + 1;
        end
        else begin
            $display("PASS: All 46 BG1 layers processed");
        end

        if (iteration_count != 1) begin
            $display("FAIL: Expected 1 iteration, got %0d",
                     iteration_count);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Iteration count = 1");
        end

        if (error || loader_error) begin
            $display("FAIL: Error signal asserted");
            errors = errors + 1;
        end

        if (iteration_limit_reached) begin
            $display("FAIL: Iteration limit unexpectedly reached");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("");
        if (errors == 0)
            $display("PASS: ALL BLOCK 19C TESTS");
        else
            $display("FAIL: %0d TEST(S) FAILED", errors);

        $display("========================================");
        $finish;
    end

endmodule
