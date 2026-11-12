
`timescale 1ns/1ps

module tb_ldpc_axi_decoder_system;

    // ------------------------------------------------
    // Parameters
    // ------------------------------------------------

    localparam DATA_WIDTH = 8;
    localparam ZC = 2;
    localparam BG1_COLUMNS = 68;
    localparam TOTAL_LLR = BG1_COLUMNS * ZC;

    // ------------------------------------------------
    // DUT inputs
    // ------------------------------------------------

    reg clk;
    reg rst_n;

    reg start;
    reg bg_select;
    reg [9:0] zc;
    reg [5:0] layer_index;

    reg [7:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire s_axis_tready;
    reg s_axis_tlast;

    // ------------------------------------------------
    // DUT outputs
    // ------------------------------------------------

    wire busy;
    wire load_done;
    wire clear_done;
    wire memory_ready;
    wire loader_error;

    wire decoder_busy;
    wire layer_done;
    wire decoder_error;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire start_error;

    wire [14:0] loaded_count;
    wire [4:0] degree;
    wire [8:0] lifted_index;

    integer i;
    integer timeout_count;
    integer errors;

    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    ldpc_axi_decoder_system DUT (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .bg_select(bg_select),
        .zc(zc),
        .layer_index(layer_index),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .busy(busy),
        .load_done(load_done),
        .clear_done(clear_done),
        .memory_ready(memory_ready),
        .loader_error(loader_error),

        .decoder_busy(decoder_busy),
        .layer_done(layer_done),
        .decoder_error(decoder_error),

        .cfg_valid(cfg_valid),
        .i_ls(i_ls),
        .start_error(start_error),

        .loaded_count(loaded_count),
        .degree(degree),
        .lifted_index(lifted_index)
    );

    // ------------------------------------------------
    // Clock: 100 MHz
    // ------------------------------------------------

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // AXI transfer task
    // ------------------------------------------------

    task send_beat;
        input [7:0] data;
        input last;
        begin
            @(negedge clk);

            s_axis_tdata  = data;
            s_axis_tvalid = 1'b1;
            s_axis_tlast  = last;

            while (s_axis_tready !== 1'b1)
                @(negedge clk);

            // Transfer accepted at this rising edge.
            @(posedge clk);

            @(negedge clk);

            s_axis_tvalid = 1'b0;
            s_axis_tlast  = 1'b0;
        end
    endtask

    // ------------------------------------------------
    // Main test
    // ------------------------------------------------

    initial begin

        errors = 0;

        rst_n = 1'b0;

        start = 1'b0;
        bg_select = 1'b0;
        zc = ZC;
        layer_index = 6'd0;

        s_axis_tdata = 8'd0;
        s_axis_tvalid = 1'b0;
        s_axis_tlast = 1'b0;

        $display("----------------------------------------");
        $display(" BLOCK 18: AXI + LDPC SYSTEM TEST");
        $display("----------------------------------------");

        // --------------------------------------------
        // TEST 1: RESET
        // --------------------------------------------

        repeat (5) @(negedge clk);
        rst_n = 1'b1;

        repeat (2) @(negedge clk);

        $display("PASS: System reset completed");

        // --------------------------------------------
        // TEST 2: CONFIGURATION
        // --------------------------------------------

        if (cfg_valid !== 1'b1) begin
            $display("FAIL: BG1 Zc=2 configuration invalid");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 Zc=2 configuration valid");
        end

        // --------------------------------------------
        // TEST 3: START CODEWORD LOADING
        // --------------------------------------------

        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        // Wait for AXI input readiness.
        timeout_count = 0;

        while (s_axis_tready !== 1'b1 &&
               timeout_count < 20) begin
            @(negedge clk);
            timeout_count = timeout_count + 1;
        end

        if (s_axis_tready !== 1'b1) begin
            $display("FAIL: AXI loader did not become ready");
            errors = errors + 1;
            $finish;
        end

        $display("PASS: AXI loader ready");

        // --------------------------------------------
        // TEST 4: SEND COMPLETE BG1 CODEWORD
        // --------------------------------------------

        $display("Loading %0d LLR values...", TOTAL_LLR);

        for (i = 0; i < TOTAL_LLR; i = i + 1) begin

            // Nonuniform signed test data.
            send_beat(
                (i * 7 + 13) % 101 - 50,
                (i == TOTAL_LLR-1)
            );

        end

        if (loaded_count !== TOTAL_LLR) begin
            $display("FAIL: Loaded count = %0d, expected %0d",
                     loaded_count, TOTAL_LLR);
            errors = errors + 1;
        end
        else begin
            $display("PASS: All %0d LLR transfers accepted",
                     loaded_count);
        end

        if (load_done !== 1'b1) begin
            $display("FAIL: load_done was not asserted");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Final AXI transfer and TLAST accepted");
        end

        // --------------------------------------------
        // TEST 5: EDGE-MESSAGE MEMORY CLEAR
        // --------------------------------------------

        $display("Waiting for edge-message memory clearing...");

        timeout_count = 0;

        while (clear_done !== 1'b1 &&
               timeout_count < 2000) begin
            @(negedge clk);
            timeout_count = timeout_count + 1;
        end

        if (clear_done !== 1'b1) begin
            $display("FAIL: Edge-memory clearing timeout");
            errors = errors + 1;
            $finish;
        end
        else begin
            $display("PASS: Edge-message memory clearing completed");
        end

        if (memory_ready !== 1'b1) begin
            $display("FAIL: memory_ready not asserted");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Shared memory ready");
        end

        // --------------------------------------------
        // TEST 6: DECODER START AND LAYER PROCESSING
        // --------------------------------------------

        $display("Waiting for BG1 layer 0 processing...");

        timeout_count = 0;

        while (layer_done !== 1'b1 &&
               timeout_count < 10000) begin
            @(negedge clk);
            timeout_count = timeout_count + 1;
        end

        if (layer_done !== 1'b1) begin
            $display("FAIL: Decoder layer completion timeout");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 layer 0 completed");
            $display("Layer processing cycles after clear: %0d",
                     timeout_count);
        end

        // --------------------------------------------
        // TEST 7: ERROR CHECK
        // --------------------------------------------

        if (loader_error !== 1'b0) begin
            $display("FAIL: Loader error detected");
            errors = errors + 1;
        end
        else begin
            $display("PASS: No AXI loader error");
        end

        if (decoder_error !== 1'b0) begin
            $display("FAIL: Decoder error detected");
            errors = errors + 1;
        end
        else begin
            $display("PASS: No decoder error");
        end

        if (start_error !== 1'b0) begin
            $display("FAIL: Decoder start error detected");
            errors = errors + 1;
        end
        else begin
            $display("PASS: No decoder configuration error");
        end

        // --------------------------------------------
        // FINAL RESULT
        // --------------------------------------------

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: ALL BLOCK 18 SYSTEM TESTS");
        end
        else begin
            $display("FAIL: %0d ERRORS DETECTED", errors);
        end

        $display("----------------------------------------");

        #20;
        $finish;

    end

    // ------------------------------------------------
    // Global simulation timeout
    // ------------------------------------------------

    initial begin
        #2000000;

        $display("FAIL: GLOBAL SIMULATION TIMEOUT");
        $finish;
    end

endmodule
