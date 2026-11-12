
`timescale 1ns/1ps

module tb_ldpc_axi_stream_top;

    reg clk;
    reg rst_n;

    reg start;
    reg bg_select;
    reg [9:0] zc;

    reg [7:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire s_axis_tready;
    reg s_axis_tlast;

    wire llr_en;
    wire llr_we;
    wire [14:0] llr_addr;
    wire signed [7:0] llr_din;

    wire busy;
    wire load_done;
    wire clear_done;
    wire memory_ready;
    wire error;
    wire cfg_valid;
    wire [14:0] loaded_count;

    integer errors;
    integer col;
    integer lift;
    integer edge_index;
    integer address;
    integer expected_columns;
    integer first_edge;
    integer last_edge;
    integer data_index;

    reg [7:0] expected_data;

    // DUT
    ldpc_axi_stream_top DUT (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .bg_select(bg_select),
        .zc(zc),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),

        .busy(busy),
        .load_done(load_done),
        .clear_done(clear_done),
        .memory_ready(memory_ready),
        .error(error),
        .cfg_valid(cfg_valid),
        .loaded_count(loaded_count)
    );

    // Clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk;


    // =====================================================
    // TASK 1: LOAD AND VERIFY A COMPLETE BASE-GRAPH VECTOR
    // =====================================================

    task run_case;
        input test_bg;
        input [9:0] test_zc;

        begin

            if (test_bg == 1'b0) begin
                expected_columns = 68;
                first_edge = 0;
                last_edge = 315;
            end
            else begin
                expected_columns = 52;
                first_edge = 316;
                last_edge = 512;
            end

            zc = test_zc;
            bg_select = test_bg;

            // Start the transaction
            @(negedge clk);
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            wait (s_axis_tready == 1'b1);

            data_index = 0;

            // Send LLRs in column-major order.
            // Address = column * 384 + lifted position.

            for (col = 0; col < expected_columns; col = col + 1) begin

                for (lift = 0; lift < test_zc; lift = lift + 1) begin

                    expected_data = (data_index * 7 + 3) & 8'hFF;

                    @(negedge clk);

                    s_axis_tdata  = expected_data;
                    s_axis_tvalid = 1'b1;

                    if ((col == expected_columns-1) &&
                        (lift == test_zc-1))
                        s_axis_tlast = 1'b1;
                    else
                        s_axis_tlast = 1'b0;

                    @(posedge clk);

                    if (s_axis_tready !== 1'b1) begin
                        $display("ERROR: TREADY low during input transfer");
                        errors = errors + 1;
                    end

                    data_index = data_index + 1;

                end
            end

            // Stop input transfers
            @(negedge clk);

            s_axis_tvalid = 1'b0;
            s_axis_tlast  = 1'b0;
            s_axis_tdata  = 8'd0;

            // Wait for edge-memory clearing to finish
            wait (clear_done == 1'b1);

            @(negedge clk);

            // Check status
            if (error !== 1'b0) begin
                $display("ERROR: DUT error asserted for BG%0d",
                         test_bg ? 2 : 1);
                errors = errors + 1;
            end

            if (memory_ready !== 1'b1) begin
                $display("ERROR: memory_ready not asserted");
                errors = errors + 1;
            end

            if (loaded_count !== expected_columns * test_zc) begin
                $display("ERROR: loaded_count mismatch. Got %0d, expected %0d",
                         loaded_count, expected_columns * test_zc);
                errors = errors + 1;
            end

            // Verify LLR memory contents
            data_index = 0;

            for (col = 0; col < expected_columns; col = col + 1) begin

                for (lift = 0; lift < test_zc; lift = lift + 1) begin

                    address = col * 384 + lift;

                    expected_data = (data_index * 7 + 3) & 8'hFF;

                    if (DUT.MEMORY.llr_mem[address] !== expected_data) begin
                        $display("ERROR: LLR mismatch at address %0d. Got %h, expected %h",
                                 address,
                                 DUT.MEMORY.llr_mem[address],
                                 expected_data);
                        errors = errors + 1;
                    end

                    data_index = data_index + 1;

                end
            end

            // Verify the correct GLOBAL edge range was cleared
            for (edge_index = first_edge;
                 edge_index <= last_edge;
                 edge_index = edge_index + 1) begin

                for (lift = 0; lift < test_zc; lift = lift + 1) begin

                    address = edge_index * 384 + lift;

                    if (DUT.MEMORY.edge_mem[address] !== 8'd0) begin
                        $display("ERROR: Edge memory not cleared at address %0d",
                                 address);
                        errors = errors + 1;
                    end

                end
            end

            $display("PASS: BG%0d, Zc=%0d, LLRs=%0d, edge range=%0d-%0d",
                     test_bg ? 2 : 1,
                     test_zc,
                     expected_columns * test_zc,
                     first_edge,
                     last_edge);

        end
    endtask


    // =====================================================
    // TASK 2: VERIFY EARLY TLAST REJECTION
    // =====================================================

    task test_early_tlast;
        begin

            @(negedge clk);

            bg_select = 1'b0;
            zc = 10'd2;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            wait (s_axis_tready == 1'b1);

            // First beat is not the final beat,
            // therefore TLAST must not be asserted.

            @(negedge clk);

            s_axis_tdata  = 8'h35;
            s_axis_tvalid = 1'b1;
            s_axis_tlast  = 1'b1;

            @(posedge clk);

            @(negedge clk);

            s_axis_tvalid = 1'b0;
            s_axis_tlast  = 1'b0;

            if (error !== 1'b1) begin
                $display("ERROR: Early TLAST was not rejected");
                errors = errors + 1;
            end
            else begin
                $display("PASS: Early TLAST correctly rejected");
            end

            if (memory_ready !== 1'b0) begin
                $display("ERROR: memory_ready asserted after early TLAST");
                errors = errors + 1;
            end

        end
    endtask


    // =====================================================
    // MAIN TEST SEQUENCE
    // =====================================================

    initial begin

        errors = 0;

        rst_n = 1'b0;

        start = 1'b0;
        bg_select = 1'b0;
        zc = 10'd2;

        s_axis_tdata = 8'd0;
        s_axis_tvalid = 1'b0;
        s_axis_tlast = 1'b0;

        // Reset
        repeat (4) @(negedge clk);
        rst_n = 1'b1;

        // -------------------------------------------------
        // TEST 1: BG1, Zc = 2
        // Expected edge range: 0 to 315
        // -------------------------------------------------

        run_case(1'b0, 10'd2);

        // Place sentinel values in BG1 edge-memory range.
        // BG2 clearing must preserve both locations.

        DUT.MEMORY.edge_mem[0] = 8'h5A;
        DUT.MEMORY.edge_mem[315*384] = 8'hA5;

        // -------------------------------------------------
        // TEST 2: BG2, Zc = 2
        // Expected edge range: 316 to 512
        // -------------------------------------------------

        run_case(1'b1, 10'd2);

        // -------------------------------------------------
        // TEST 3: Verify BG1 memory was not modified by BG2
        // -------------------------------------------------

        if (DUT.MEMORY.edge_mem[0] !== 8'h5A) begin
            $display("ERROR: BG2 clearing modified edge address 0");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 edge address 0 preserved");
        end

        if (DUT.MEMORY.edge_mem[315*384] !== 8'hA5) begin
            $display("ERROR: BG2 clearing modified edge 315");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG1 edge address 315 preserved");
        end

        // -------------------------------------------------
        // TEST 4: Verify highest BG2 edge address
        // -------------------------------------------------

        if (DUT.MEMORY.edge_mem[512*384] !== 8'd0) begin
            $display("ERROR: BG2 edge 512 was not cleared");
            errors = errors + 1;
        end
        else begin
            $display("PASS: BG2 final edge address 512 cleared");
        end

        // -------------------------------------------------
        // TEST 5: Early TLAST rejection
        // -------------------------------------------------

        test_early_tlast();

        // -------------------------------------------------
        // FINAL RESULT
        // -------------------------------------------------

        if (errors == 0)
            $display("\nPASS: ALL AXI INPUT AND MEMORY CLEARING TESTS");
        else
            $display("\nFAIL: %0d ERRORS DETECTED", errors);

        $finish;

    end


    // Simulation timeout
    initial begin
        #10000000;
        $display("ERROR: Testbench timeout");
        $finish;
    end

endmodule
