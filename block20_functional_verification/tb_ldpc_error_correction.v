
`timescale 1ns/1ps

module tb_ldpc_error_correction #(
    parameter integer ERROR_INDEX = 0
);
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

    // LLR memory Port B readback
    reg llr_readback_en;
    reg [14:0] llr_readback_addr;
    wire [7:0] llr_readback_data;

    integer i;
    integer timeout_count;
    integer layer_count;
    integer hard_errors;
    integer readback_errors;
    integer functional_pass;

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

        .llr_readback_en(llr_readback_en),
        .llr_readback_addr(llr_readback_addr),
        .llr_readback_data(llr_readback_data)
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

    // AXI4-Stream transfer task
    task send_beat;
        input [7:0] data;
        input last;

        begin
            @(negedge clk);

            s_axis_tdata = data;
            s_axis_tlast = last;
            s_axis_tvalid = 1'b1;

            while (s_axis_tready !== 1'b1)
                @(negedge clk);

            @(posedge clk);
            @(negedge clk);

            s_axis_tvalid = 1'b0;
            s_axis_tlast = 1'b0;
        end
    endtask

// Main experiment
initial begin

    functional_pass = 1;

    // Validate injected error location
    if (ERROR_INDEX < 0 || ERROR_INDEX >= 136) begin
        $display("FAIL: ERROR_INDEX must be between 0 and 135");
        $finish;
    end

    hard_errors = 0;
    readback_errors = 0;
    layer_count = 0;

    rst_n = 1'b0;

    start = 1'b0;
    bg_select = 1'b0;
    zc = 10'd2;
    max_iterations = 8'd10;

    s_axis_tdata = 8'd0;
    s_axis_tvalid = 1'b0;
    s_axis_tlast = 1'b0;

    llr_readback_en = 1'b0;
    llr_readback_addr = 15'd0;

    $display("");
    $display("========================================");
    $display(" BLOCK 20: FUNCTIONAL ERROR CORRECTION");
    $display("========================================");

    // Reset
    repeat (5) @(posedge clk);

    @(negedge clk);
    rst_n = 1'b1;

    // Configuration check
    @(posedge clk);
        #1;

        if (cfg_valid !== 1'b1) begin
            $display("FAIL: Invalid BG1 Zc=2 configuration");
            functional_pass = 0;
        end
        else begin
            $display("PASS: BG1 Zc=2 configuration valid");
        end

        // Start loader
        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        // Load all-zero codeword with one corrupted LLR.
        // Address 0 receives -20 (8'hEC).
        // All remaining addresses receive +20 (8'h14).

        $display("Loading 136 LLR values...");
$display("Corrupted input index: %0d", ERROR_INDEX);
$display("Physical LLR address: %0d",
         (ERROR_INDEX / 2) * 384 + (ERROR_INDEX % 2));
        for (i = 0; i < 136; i = i + 1) begin

            if (i == ERROR_INDEX)
                send_beat(8'hEC, (i == 135));
            else
                send_beat(8'h14, (i == 135));

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
            functional_pass = 0;
        end
        else begin
            $display("PASS: LLR loading and edge clearing");
        end

        if (loaded_count !== 15'd136) begin
            $display("FAIL: Loaded count = %0d", loaded_count);
            functional_pass = 0;
        end
        else begin
            $display("PASS: All 136 LLRs loaded");
        end

        if (loader_error !== 1'b0) begin
            $display("FAIL: Loader error");
            functional_pass = 0;
        end

        // Wait for decoder completion
        $display("Waiting for decoder completion...");

        timeout_count = 0;

        while (done !== 1'b1 &&
               timeout_count < 500000) begin

            @(posedge clk);
            timeout_count = timeout_count + 1;

        end

        #1;

        if (done !== 1'b1) begin
            $display("FAIL: Decoder completion timeout");
            functional_pass = 0;
        end
        else begin
            $display("PASS: Decoder completed in %0d cycles",
                     timeout_count);
        end

        if (layer_count !== 46) begin
            $display("FAIL: Expected 46 layers, got %0d",
                     layer_count);
            functional_pass = 0;
        end
        else begin
            $display("PASS: All 46 BG1 layers processed");
        end

        $display("Iterations used: %0d", iteration_count);
        $display("Syndrome result: %0b", syndrome_pass);
        $display("Decoder success: %0b", decoder_success);

        if (error !== 1'b0) begin
            $display("FAIL: Hardware error asserted");
            functional_pass = 0;
        end

        // ----------------------------------------
        // Read back all 136 final LLR values
        // ----------------------------------------

        $display("");
        $display("Reading final LLR memory contents...");

for (i = 0; i < 136; i = i + 1) begin

    @(negedge clk);

    llr_readback_en = 1'b1;

    // Correct physical address mapping for Zc = 2
    llr_readback_addr = (i / 2) * 384 + (i % 2);

    @(posedge clk);
    #1;

    if ((^llr_readback_data) === 1'bx) begin

        readback_errors = readback_errors + 1;

        $display("UNKNOWN: address=%0d",
                 llr_readback_addr);

    end
    else if ($signed(llr_readback_data) < 0) begin

        hard_errors = hard_errors + 1;

        $display("Remaining hard error: address=%0d LLR=%0d",
                 llr_readback_addr,
                 $signed(llr_readback_data));

    end

    @(negedge clk);
    llr_readback_en = 1'b0;

end

if (readback_errors != 0) begin
    $display("FAIL: %0d unknown readback values",
             readback_errors);
    functional_pass = 0;
end
        $display("");
        $display("Readback completed.");
        $display("Remaining hard-decision errors: %0d",
                 hard_errors);

        // ----------------------------------------
        // Final functional result
        // ----------------------------------------

        if (syndrome_pass !== 1'b1) begin
            $display("FAIL: Syndrome did not converge");
            functional_pass = 0;
        end

if (hard_errors != 0 || readback_errors != 0) begin
    $display("FAIL: Codeword recovery not verified");
    functional_pass = 0;
end
        if (busy !== 1'b0) begin
            $display("FAIL: Decoder did not return to idle");
            functional_pass = 0;
        end

        $display("");
        $display("========================================");
        $display(" BLOCK 20 FUNCTIONAL TEST SUMMARY");
        $display("========================================");

        $display("BG1, Zc=2");
        $display("Injected errors: 1");
        $display("Remaining hard errors: %0d", hard_errors);
        $display("Syndrome pass: %0b", syndrome_pass);

        if (functional_pass)
            $display("PASS: ONE-BIT ERROR CORRECTED");
        else
            $display("FAIL: FUNCTIONAL CORRECTION NOT VERIFIED");

        $display("========================================");

        $finish;

    end

endmodule
