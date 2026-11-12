
`timescale 1ns/1ps

module tb_ldpc_bg_layer_processor;

    reg clk;
    reg rst_n;
    reg start;

    reg bg_select;
    reg [5:0] layer_index;
    reg [9:0] zc;

    wire llr_en;
    wire llr_we;
    wire [14:0] llr_addr;
    wire [7:0] llr_din;
    reg signed [7:0] llr_dout;

    wire edge_mem_en;
    wire edge_mem_we;
    wire [17:0] edge_mem_addr;
    wire [7:0] edge_mem_din;
    reg signed [7:0] edge_mem_dout;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire start_error;

    wire busy;
    wire layer_done;
    wire error;

    wire [4:0] degree;
    wire [8:0] lifted_index;

    reg signed [7:0] llr_mem [0:32767];
    reg signed [7:0] edge_mem [0:262143];

    integer llr_write_count;
    integer edge_write_count;
    integer errors;
    integer cycles;
    integer i;

    ldpc_bg_layer_processor DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .layer_index(layer_index),
        .zc(zc),
        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout),
        .edge_mem_en(edge_mem_en),
        .edge_mem_we(edge_mem_we),
        .edge_mem_addr(edge_mem_addr),
        .edge_mem_din(edge_mem_din),
        .edge_mem_dout(edge_mem_dout),
        .cfg_valid(cfg_valid),
        .i_ls(i_ls),
        .start_error(start_error),
        .busy(busy),
        .layer_done(layer_done),
        .error(error),
        .degree(degree),
        .lifted_index(lifted_index)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Synchronous memory model
    always @(posedge clk) begin

        if (llr_en) begin
            if (llr_we) begin
                llr_mem[llr_addr] <= llr_din;
                llr_write_count <= llr_write_count + 1;
            end
            else begin
                llr_dout <= llr_mem[llr_addr];
            end
        end

        if (edge_mem_en) begin
            if (edge_mem_we) begin
                edge_mem[edge_mem_addr] <= edge_mem_din;
                edge_write_count <= edge_write_count + 1;
            end
            else begin
                edge_mem_dout <= edge_mem[edge_mem_addr];
            end
        end
    end

    task apply_reset;
        begin
            @(negedge clk);
            rst_n = 0;
            start = 0;

            repeat (3) @(negedge clk);

            rst_n = 1;
            @(negedge clk);
        end
    endtask

    task issue_start;
        begin
            @(negedge clk);
            start = 1;

            @(negedge clk);
            start = 0;
        end
    endtask

    task wait_for_completion;
        begin
            cycles = 0;

            while (layer_done !== 1'b1 && cycles < 20000) begin
                @(negedge clk);
                cycles = cycles + 1;
            end

            if (layer_done !== 1'b1) begin
                $display("ERROR: Layer processing timeout");
                errors = errors + 1;
            end
            else begin
                $display("Layer completion received after %0d cycles",
                         cycles);
            end
        end
    endtask

    initial begin

        $display("========================================");
        $display("BLOCK 15: BG LAYER PROCESSOR TEST");
        $display("========================================");

        errors = 0;
        llr_write_count = 0;
        edge_write_count = 0;

        rst_n = 0;
        start = 0;
        bg_select = 0;
        layer_index = 0;
        zc = 8;

        llr_dout = 0;
        edge_mem_dout = 0;

        for (i = 0; i < 32768; i = i + 1)
            llr_mem[i] = 8'sd20;

        for (i = 0; i < 262144; i = i + 1)
            edge_mem[i] = 8'sd0;

        apply_reset();

        // ----------------------------------------
        // TEST 1: BG1, layer 0, Zc = 8
        // ----------------------------------------

        $display("");
        $display("TEST 1: BG1 layer 0, Zc=8");

        bg_select = 0;
        layer_index = 0;
        zc = 8;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: Legal Zc rejected");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Legal lifting size accepted");
        end

        if (i_ls !== 3'd0) begin
            $display("ERROR: Incorrect iLS value: %0d", i_ls);
            errors = errors + 1;
        end
        else begin
            $display("PASS: iLS decoded correctly");
        end

        issue_start();
        wait_for_completion();

        if (busy !== 1'b0) begin
            $display("ERROR: Busy remained high after completion");
            errors = errors + 1;
        end

        if (error !== 1'b0) begin
            $display("ERROR: Processing error asserted");
            errors = errors + 1;
        end

        $display("LLR writes         : %0d", llr_write_count);
        $display("Edge-message writes: %0d", edge_write_count);

        if (llr_write_count != 152) begin
            $display("ERROR: Expected 152 LLR writes");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 LLR write count");
        end

        if (edge_write_count != 152) begin
            $display("ERROR: Expected 152 edge-message writes");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 edge-message write count");
        end

        // ----------------------------------------
        // TEST 2: BG2, layer 0, Zc = 8
        // ----------------------------------------

        $display("");
        $display("TEST 2: BG2 layer 0, Zc=8");

        apply_reset();

        llr_write_count = 0;
        edge_write_count = 0;

        bg_select = 1;
        layer_index = 0;
        zc = 8;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: BG2 legal Zc rejected");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG2 legal lifting size accepted");
        end

        if (i_ls !== 3'd0) begin
            $display("ERROR: Incorrect BG2 iLS value: %0d", i_ls);
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG2 iLS decoded correctly");
        end

        issue_start();
        wait_for_completion();

        if (busy !== 1'b0) begin
            $display("ERROR: BG2 busy remained high");
            errors = errors + 1;
        end

        if (error !== 1'b0) begin
            $display("ERROR: BG2 processing error asserted");
            errors = errors + 1;
        end

        $display("BG2 LLR writes         : %0d", llr_write_count);
        $display("BG2 edge-message writes: %0d", edge_write_count);

        if (llr_write_count != 64) begin
            $display("ERROR: Expected 64 BG2 LLR writes");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG2 LLR write count");
        end

        if (edge_write_count != 64) begin
            $display("ERROR: Expected 64 BG2 edge-message writes");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG2 edge-message write count");
        end

        // ----------------------------------------
        // TEST 3: Invalid lifting size
        // ----------------------------------------

        $display("");
        $display("TEST 3: Invalid lifting size");

        apply_reset();

        bg_select = 0;
        layer_index = 0;
        zc = 17;

        #1;

        if (cfg_valid !== 1'b0) begin
            $display("ERROR: Invalid Zc was accepted");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Invalid Zc rejected");
        end

        issue_start();
        @(negedge clk);

        if (start_error !== 1'b1) begin
            $display("ERROR: Invalid configuration error missing");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Invalid configuration reported");
        end

        if (busy !== 1'b0) begin
            $display("ERROR: Processor started with invalid Zc");
            errors = errors + 1;
        end

        // ----------------------------------------
        // TEST 4: Invalid BG1 layer index
        // ----------------------------------------

        $display("");
        $display("TEST 4: Invalid BG1 layer index");

        apply_reset();

        bg_select = 0;
        layer_index = 46;
        zc = 8;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: Legal Zc rejected in layer test");
            errors = errors + 1;
        end

        issue_start();
        @(negedge clk);

        if (start_error !== 1'b1) begin
            $display("ERROR: Invalid layer error missing");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Invalid BG1 layer rejected");
        end

        if (busy !== 1'b0) begin
            $display("ERROR: Processor started with invalid layer");
            errors = errors + 1;
        end

        // ----------------------------------------
        // FINAL SUMMARY
        // ----------------------------------------

        $display("");
        $display("========================================");
        $display("BLOCK 15 TEST SUMMARY");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BLOCK 15 BG LAYER PROCESSOR");
        else
            $display("FAIL: BLOCK 15 BG LAYER PROCESSOR");

        $display("========================================");

        $finish;
    end

    initial begin
        #5000000;
        $display("FATAL: Testbench global timeout");
        $finish;
    end

endmodule
