
`timescale 1ns/1ps

module tb_ldpc_bg_layer_processor;

    reg clk, rst_n, start;
    reg bg_select;
    reg [5:0] layer_index;
    reg [9:0] zc;

    wire llr_en, llr_we;
    wire [14:0] llr_addr;
    wire [7:0] llr_din;
    reg signed [7:0] llr_dout;

    wire edge_mem_en, edge_mem_we;
    wire [17:0] edge_mem_addr;
    wire [7:0] edge_mem_din;
    reg signed [7:0] edge_mem_dout;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire start_error;
    wire busy, layer_done, error;
    wire [4:0] degree;
    wire [8:0] lifted_index;

    reg signed [7:0] llr_mem [0:32767];
    reg signed [7:0] edge_mem [0:262143];

    integer llr_write_count;
    integer edge_write_count;
    integer bad_llr_data;
    integer bad_edge_data;
    integer bad_llr_addr;
    integer bad_edge_addr;
    integer bad_llr_lift;
    integer bad_edge_lift;

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

    // Initialize both behavioral memories to known values.
    task initialize_memories;
        integer j;
        begin
            for (j = 0; j < 32768; j = j + 1)
                llr_mem[j] = 8'sd20;

            for (j = 0; j < 262144; j = j + 1)
                edge_mem[j] = 8'sd0;

            llr_dout = 0;
            edge_mem_dout = 0;
        end
    endtask

    // Synchronous memory model and write-data/address monitors.
    always @(posedge clk) begin

        if (llr_en) begin
            if (llr_we) begin
                llr_mem[llr_addr] <= llr_din;
                llr_write_count <= llr_write_count + 1;

                if (llr_din !== 8'd40)
                    bad_llr_data <= bad_llr_data + 1;

                if (llr_addr >= 26112)
                    bad_llr_addr <= bad_llr_addr + 1;

                if ((llr_addr % 384) >= zc)
                    bad_llr_lift <= bad_llr_lift + 1;
            end
            else begin
                llr_dout <= llr_mem[llr_addr];
            end
        end

        if (edge_mem_en) begin
            if (edge_mem_we) begin
                edge_mem[edge_mem_addr] <= edge_mem_din;
                edge_write_count <= edge_write_count + 1;

                if (edge_mem_din !== 8'd20)
                    bad_edge_data <= bad_edge_data + 1;

                if (edge_mem_addr >= 196992)
                    bad_edge_addr <= bad_edge_addr + 1;

                if ((edge_mem_addr % 384) >= zc)
                    bad_edge_lift <= bad_edge_lift + 1;
            end
            else begin
                edge_mem_dout <= edge_mem[edge_mem_addr];
            end
        end
    end

    task clear_counters;
        begin
            llr_write_count = 0;
            edge_write_count = 0;
            bad_llr_data = 0;
            bad_edge_data = 0;
            bad_llr_addr = 0;
            bad_edge_addr = 0;
            bad_llr_lift = 0;
            bad_edge_lift = 0;
        end
    endtask

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

    task check_data_and_addresses;
        begin
            $display("LLR writes           : %0d", llr_write_count);
            $display("Edge-message writes  : %0d", edge_write_count);

            $display("Incorrect LLR data   : %0d", bad_llr_data);
            $display("Incorrect edge data  : %0d", bad_edge_data);
            $display("Invalid LLR address  : %0d", bad_llr_addr);
            $display("Invalid edge address : %0d", bad_edge_addr);
            $display("Invalid LLR lift idx : %0d", bad_llr_lift);
            $display("Invalid edge lift idx: %0d", bad_edge_lift);

            if (bad_llr_data != 0) begin
                $display("ERROR: Incorrect LLR write data");
                errors = errors + 1;
            end
            else
                $display("PASS: All LLR write data values");

            if (bad_edge_data != 0) begin
                $display("ERROR: Incorrect edge-message write data");
                errors = errors + 1;
            end
            else
                $display("PASS: All edge-message write data values");

            if (bad_llr_addr != 0 || bad_edge_addr != 0) begin
                $display("ERROR: Memory address outside allocated range");
                errors = errors + 1;
            end
            else
                $display("PASS: Memory address ranges");

            if (bad_llr_lift != 0 || bad_edge_lift != 0) begin
                $display("ERROR: Invalid lifted address component");
                errors = errors + 1;
            end
            else
                $display("PASS: Lifted address components");
        end
    endtask

    initial begin

        $display("========================================");
        $display("BLOCK 15: DATA-LEVEL VERIFICATION");
        $display("========================================");

        errors = 0;
        clear_counters();

        rst_n = 0;
        start = 0;
        bg_select = 0;
        layer_index = 0;
        zc = 8;

        initialize_memories();

        apply_reset();

        // TEST 1: BG1 layer 0
        $display("");
        $display("TEST 1: BG1 layer 0, Zc=8");

        bg_select = 0;
        layer_index = 0;
        zc = 8;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: BG1 legal Zc rejected");
            errors = errors + 1;
        end
        else
            $display("PASS: BG1 legal Zc accepted");

        if (i_ls !== 3'd0) begin
            $display("ERROR: Incorrect BG1 iLS");
            errors = errors + 1;
        end
        else
            $display("PASS: BG1 iLS decoded");

        issue_start();
        wait_for_completion();

        if (llr_write_count != 152) begin
            $display("ERROR: BG1 expected 152 LLR writes");
            errors = errors + 1;
        end
        else
            $display("PASS: BG1 LLR write count");

        if (edge_write_count != 152) begin
            $display("ERROR: BG1 expected 152 edge writes");
            errors = errors + 1;
        end
        else
            $display("PASS: BG1 edge write count");

        check_data_and_addresses();

        if (busy !== 1'b0 || error !== 1'b0) begin
            $display("ERROR: BG1 final status incorrect");
            errors = errors + 1;
        end

        // TEST 2: BG2 layer 0
        $display("");
        $display("TEST 2: BG2 layer 0, Zc=8");

        apply_reset();
        clear_counters();

        // IMPORTANT: Restore original memory values before BG2.
        initialize_memories();

        bg_select = 1;
        layer_index = 0;
        zc = 8;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: BG2 legal Zc rejected");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 legal Zc accepted");

        if (i_ls !== 3'd0) begin
            $display("ERROR: Incorrect BG2 iLS");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 iLS decoded");

        issue_start();
        wait_for_completion();

        if (llr_write_count != 64) begin
            $display("ERROR: BG2 expected 64 LLR writes");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 LLR write count");

        if (edge_write_count != 64) begin
            $display("ERROR: BG2 expected 64 edge writes");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 edge write count");

        check_data_and_addresses();

        if (busy !== 1'b0 || error !== 1'b0) begin
            $display("ERROR: BG2 final status incorrect");
            errors = errors + 1;
        end

        // TEST 3: Invalid lifting size
        $display("");
        $display("TEST 3: Invalid lifting size");

        apply_reset();

        bg_select = 0;
        layer_index = 0;
        zc = 17;

        #1;

        if (cfg_valid !== 1'b0) begin
            $display("ERROR: Invalid Zc accepted");
            errors = errors + 1;
        end
        else
            $display("PASS: Invalid Zc rejected");

        issue_start();
        @(negedge clk);

        if (start_error !== 1'b1) begin
            $display("ERROR: Invalid configuration error missing");
            errors = errors + 1;
        end
        else
            $display("PASS: Invalid configuration reported");

        if (busy !== 1'b0) begin
            $display("ERROR: Processor started with invalid Zc");
            errors = errors + 1;
        end

        // TEST 4: Invalid BG1 layer index
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
        else
            $display("PASS: Invalid BG1 layer rejected");

        if (busy !== 1'b0) begin
            $display("ERROR: Processor started with invalid layer");
            errors = errors + 1;
        end

        // FINAL SUMMARY
        $display("");
        $display("========================================");
        $display("BLOCK 15 DATA-LEVEL TEST SUMMARY");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BLOCK 15 DATA-LEVEL VERIFICATION");
        else
            $display("FAIL: BLOCK 15 DATA-LEVEL VERIFICATION");

        $display("========================================");
        $finish;
    end

    initial begin
        #5000000;
        $display("FATAL: Testbench global timeout");
        $finish;
    end

endmodule
