
`timescale 1ns/1ps

module tb_ldpc_layer_processing_wrapper;

    parameter DATA_WIDTH = 8;
    parameter MAX_DEGREE = 19;
    parameter DEGREE_WIDTH = 5;
    parameter LLR_ADDR_WIDTH = 15;
    parameter EDGE_ADDR_WIDTH = 18;

    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    reg bg_select = 0;
    reg [9:0] zc = 10'd8;

    reg edge_valid = 0;
    wire edge_ready;
    reg edge_last = 0;

    reg [5:0] row_index = 0;
    reg [6:0] col_index = 0;
    reg [8:0] shift_value = 0;
    reg [9:0] current_edge_addr = 0;

    wire llr_en;
    wire llr_we;
    wire [LLR_ADDR_WIDTH-1:0] llr_addr;
    wire [DATA_WIDTH-1:0] llr_din;
    wire signed [DATA_WIDTH-1:0] llr_dout;

    wire edge_mem_en;
    wire edge_mem_we;
    wire [EDGE_ADDR_WIDTH-1:0] edge_mem_addr;
    wire [DATA_WIDTH-1:0] edge_mem_din;
    wire signed [DATA_WIDTH-1:0] edge_mem_dout;

    wire busy;
    wire layer_done;
    wire error;

    wire [DEGREE_WIDTH-1:0] degree;
    wire [8:0] lifted_index;

    integer i;
    integer e;
    integer source;
    integer shift_amount;
    integer timeout;
    integer errors;

    always #5 clk = ~clk;

    // ================================================
    // DUT: COMPLETE LAYER PROCESSING WRAPPER
    // ================================================

    ldpc_layer_processing_wrapper DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .zc(zc),

        .edge_valid(edge_valid),
        .edge_ready(edge_ready),
        .edge_last(edge_last),

        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value),
        .current_edge_addr(current_edge_addr),

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

        .busy(busy),
        .layer_done(layer_done),
        .error(error),

        .degree(degree),
        .lifted_index(lifted_index)
    );

    // ================================================
    // DUAL MEMORY
    // ================================================

    ldpc_message_memory MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout),

        .edge_en(edge_mem_en),
        .edge_we(edge_mem_we),
        .edge_addr(edge_mem_addr),
        .edge_din(edge_mem_din),
        .edge_dout(edge_mem_dout)
    );

    // ================================================
    // SEND ONE EDGE METADATA ENTRY
    // ================================================

    task send_edge;
        input [6:0] column;
        input [8:0] shift;
        input [9:0] edge_number;
        input last_edge;

        begin
            @(negedge clk);

            edge_valid = 1'b1;
            col_index = column;
            shift_value = shift;
            current_edge_addr = edge_number;
            edge_last = last_edge;

            while (edge_ready !== 1'b1)
                @(negedge clk);

            @(posedge clk);
            @(negedge clk);

            edge_valid = 1'b0;
            edge_last = 1'b0;
        end
    endtask

    // ================================================
    // MAIN TEST
    // ================================================

    initial begin

        errors = 0;

        $display("========================================");
        $display("BLOCK 14E LAYER PROCESSING INTEGRATION");
        $display("========================================");

        // Initialize memory contents.

        for (i = 0; i < 26112; i = i + 1)
            MEMORY.llr_mem[i] = 0;

        for (i = 0; i < 196992; i = i + 1)
            MEMORY.edge_mem[i] = 0;

        // Three synthetic BG1 edges:
        // Columns 0, 1, 2
        // Shifts 0, 1, 3

        for (e = 0; e < 3; e = e + 1) begin

            for (i = 0; i < 8; i = i + 1) begin

                case (e)
                    0: shift_amount = 0;
                    1: shift_amount = 1;
                    default: shift_amount = 3;
                endcase

                source = (i + shift_amount) % 8;

                MEMORY.llr_mem[e*384 + source] =
                    20 + e*10 + i;

                MEMORY.edge_mem[e*384 + i] = 0;

            end
        end

        // Reset

        repeat (3) @(posedge clk);

        @(negedge clk);
        rst_n = 1'b1;

        // Start both controllers.

        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        // ============================================
        // TEST 1: SEND EDGE METADATA
        // ============================================

        $display("TEST 1: Send three edge entries");

        send_edge(7'd0, 9'd0, 10'd0, 1'b0);
        send_edge(7'd1, 9'd1, 10'd1, 1'b0);
        send_edge(7'd2, 9'd3, 10'd2, 1'b1);

        $display("Three edge entries submitted");

        // ============================================
        // TEST 2: WAIT FOR LAYER COMPLETION
        // ============================================

        $display("TEST 2: Wait for layer completion");

        timeout = 0;

        // Sample at negative clock edges to avoid
        // missing the one-cycle completion pulse.

        while ((layer_done !== 1'b1) &&
               (timeout < 20000)) begin

            @(negedge clk);
            timeout = timeout + 1;

        end

        if (layer_done !== 1'b1) begin

            $display("ERROR: Layer completion timeout");
            errors = errors + 1;

        end
        else begin

            $display("Layer completion received");

        end

        if (error !== 1'b0) begin

            $display("ERROR: Controller reported an error");
            errors = errors + 1;

        end

        if (degree !== 3) begin

            $display("ERROR: Expected degree 3, got %0d", degree);
            errors = errors + 1;

        end

        // ============================================
        // TEST 3: VERIFY MEMORY WRITEBACK
        // ============================================

        $display("TEST 3: Verify memory writeback");

        for (e = 0; e < 3; e = e + 1) begin

            for (i = 0; i < 8; i = i + 1) begin

                case (e)
                    0: shift_amount = 0;
                    1: shift_amount = 1;
                    default: shift_amount = 3;
                endcase

                source = (i + shift_amount) % 8;

                // Check edge-message memory update.

                if (MEMORY.edge_mem[e*384 + i] == 0) begin

                    $display(
                        "ERROR: Edge message not updated: edge=%0d lift=%0d",
                        e, i
                    );

                    errors = errors + 1;

                end

                // Check LLR memory update.

                if (MEMORY.llr_mem[e*384 + source] ==
                    (20 + e*10 + i)) begin

                    $display(
                        "ERROR: LLR not updated: edge=%0d lift=%0d",
                        e, i
                    );

                    errors = errors + 1;

                end

            end
        end

        // ============================================
        // TEST SUMMARY
        // ============================================

        $display("----------------------------------------");
        $display("BLOCK 14E TEST SUMMARY");
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BLOCK 14E LAYER PROCESSING");
        else
            $display("FAIL: BLOCK 14E LAYER PROCESSING");

        $display("========================================");

        $finish;

    end

endmodule
