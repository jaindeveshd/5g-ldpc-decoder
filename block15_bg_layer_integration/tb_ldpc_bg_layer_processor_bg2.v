
`timescale 1ns/1ps

module tb_ldpc_bg_layer_processor_bg2;

    localparam integer DEGREE = 8;
    localparam integer ZC_TEST = 8;
    localparam integer FIRST_EDGE = 316;
    localparam integer EXPECTED_WRITES = DEGREE * ZC_TEST;

    reg clk, rst_n, start;
    reg bg_select;
    reg [5:0] layer_index;
    reg [9:0] zc;

    wire cfg_valid;
    wire [2:0] i_ls;
    wire start_error, busy, layer_done, error;
    wire [4:0] degree;
    wire [8:0] lifted_index;

    wire llr_en, llr_we;
    wire [14:0] llr_addr;
    wire [7:0] llr_din;
    reg signed [7:0] llr_dout;

    wire edge_mem_en, edge_mem_we;
    wire [17:0] edge_mem_addr;
    wire [7:0] edge_mem_din;
    reg signed [7:0] edge_mem_dout;

    reg [7:0] llr_mem [0:32767];
    reg [7:0] edge_mem [0:262143];

    // Independent reference ROM
    reg ref_bg;
    reg [9:0] ref_edge_addr;
    reg [2:0] ref_i_ls;
    reg [9:0] ref_zc;

    wire ref_edge_valid;
    wire [5:0] ref_row;
    wire [6:0] ref_col;
    wire [8:0] ref_shift;

    integer ref_col_table [0:7];
    integer ref_shift_table [0:7];
    integer ref_edge_table [0:7];

    integer q_ref [0:7];

    reg [14:0] expected_llr_addr [0:63];
    reg [17:0] expected_edge_addr [0:63];
    reg [7:0] expected_llr_data [0:63];
    reg [7:0] expected_edge_data [0:63];

    integer llr_write_count;
    integer edge_write_count;
    integer errors;
    integer golden_checks;
    integer wait_cycles;

    integer i, j, k, e, idx;
    integer llr_address_ref, edge_address_ref;
    integer q_value, q_magnitude;
    integer minimum_magnitude, sign_parity;
    integer r_value, l_value;

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

    bg_rom REF_ROM (
        .bg_select(ref_bg),
        .edge_addr(ref_edge_addr),
        .i_ls(ref_i_ls),
        .zc(ref_zc),
        .edge_valid(ref_edge_valid),
        .row_index(ref_row),
        .col_index(ref_col),
        .shift_value(ref_shift)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    function integer sat8;
        input integer value;
        begin
            if (value > 127)
                sat8 = 127;
            else if (value < -128)
                sat8 = -128;
            else
                sat8 = value;
        end
    endfunction

    function integer initial_llr;
        input integer address;
        begin
            initial_llr = ((address * 13 + 7) % 81) - 40;
        end
    endfunction

    function integer initial_edge;
        input integer address;
        begin
            initial_edge = ((address * 7 + 3) % 31) - 15;
        end
    endfunction

    // Synchronous behavioral memories and writeback monitor
    always @(posedge clk) begin
        if (!rst_n) begin
            llr_dout <= 0;
            edge_mem_dout <= 0;
        end
        else begin
            if (llr_en) begin
                if (llr_we) begin
                    if (llr_addr < 32768) begin
                        llr_mem[llr_addr] <= llr_din;

                        if (llr_write_count < EXPECTED_WRITES) begin
                            if (llr_addr !== expected_llr_addr[llr_write_count]) begin
                                $display("LLR ADDRESS ERROR [%0d]: got=%0d expected=%0d",
                                    llr_write_count, llr_addr,
                                    expected_llr_addr[llr_write_count]);
                                errors = errors + 1;
                            end

                            if (llr_din !== expected_llr_data[llr_write_count]) begin
                                $display("LLR DATA ERROR [%0d]: addr=%0d got=%0d expected=%0d",
                                    llr_write_count, llr_addr,
                                    $signed(llr_din),
                                    $signed(expected_llr_data[llr_write_count]));
                                errors = errors + 1;
                            end
                        end
                        else begin
                            $display("UNEXPECTED EXTRA LLR WRITE");
                            errors = errors + 1;
                        end

                        llr_write_count = llr_write_count + 1;
                    end
                    else begin
                        $display("LLR ADDRESS OUT OF RANGE");
                        errors = errors + 1;
                    end
                end
                else begin
                    if (llr_addr < 32768)
                        llr_dout <= llr_mem[llr_addr];
                    else
                        llr_dout <= 0;
                end
            end

            if (edge_mem_en) begin
                if (edge_mem_we) begin
                    if (edge_mem_addr < 262144) begin
                        edge_mem[edge_mem_addr] <= edge_mem_din;

                        if (edge_write_count < EXPECTED_WRITES) begin
                            if (edge_mem_addr !== expected_edge_addr[edge_write_count]) begin
                                $display("EDGE ADDRESS ERROR [%0d]: got=%0d expected=%0d",
                                    edge_write_count, edge_mem_addr,
                                    expected_edge_addr[edge_write_count]);
                                errors = errors + 1;
                            end

                            if (edge_mem_din !== expected_edge_data[edge_write_count]) begin
                                $display("EDGE DATA ERROR [%0d]: addr=%0d got=%0d expected=%0d",
                                    edge_write_count, edge_mem_addr,
                                    $signed(edge_mem_din),
                                    $signed(expected_edge_data[edge_write_count]));
                                errors = errors + 1;
                            end
                        end
                        else begin
                            $display("UNEXPECTED EXTRA EDGE WRITE");
                            errors = errors + 1;
                        end

                        edge_write_count = edge_write_count + 1;
                    end
                    else begin
                        $display("EDGE ADDRESS OUT OF RANGE");
                        errors = errors + 1;
                    end
                end
                else begin
                    if (edge_mem_addr < 262144)
                        edge_mem_dout <= edge_mem[edge_mem_addr];
                    else
                        edge_mem_dout <= 0;
                end
            end
        end
    end

    task initialize_memories;
        begin
            for (i = 0; i < 32768; i = i + 1)
                llr_mem[i] = initial_llr(i);

            for (i = 0; i < 262144; i = i + 1)
                edge_mem[i] = initial_edge(i);

            llr_dout = 0;
            edge_mem_dout = 0;
        end
    endtask

    task capture_reference_metadata;
        begin
            ref_bg = 1'b1;
            ref_i_ls = 3'd0;
            ref_zc = ZC_TEST;

            for (e = 0; e < DEGREE; e = e + 1) begin
                ref_edge_addr = FIRST_EDGE + e;
                #1;

                if (ref_edge_valid !== 1'b1) begin
                    $display("REFERENCE ROM ERROR: edge %0d invalid",
                        FIRST_EDGE + e);
                    errors = errors + 1;
                end

                ref_col_table[e] = ref_col;
                ref_shift_table[e] = ref_shift;
                ref_edge_table[e] = FIRST_EDGE + e;
            end

            $display("Reference metadata captured for %0d BG2 edges",
                DEGREE);
        end
    endtask

    task build_golden_model;
        begin
            golden_checks = 0;

            for (k = 0; k < ZC_TEST; k = k + 1) begin

                // Variable-node Q calculation
                for (e = 0; e < DEGREE; e = e + 1) begin
                    llr_address_ref =
                        ref_col_table[e] * 384 +
                        ((k + ref_shift_table[e]) % ZC_TEST);

                    edge_address_ref =
                        ref_edge_table[e] * 384 + k;

                    q_value =
                        $signed(llr_mem[llr_address_ref]) -
                        $signed(edge_mem[edge_address_ref]);

                    q_ref[e] = sat8(q_value);
                end

                // Independent check-node Min-Sum calculation
                for (e = 0; e < DEGREE; e = e + 1) begin
                    minimum_magnitude = 100000;
                    sign_parity = 0;

                    for (j = 0; j < DEGREE; j = j + 1) begin
                        if (j != e) begin
                            q_magnitude = q_ref[j];

                            if (q_magnitude < 0)
                                q_magnitude = -q_magnitude;

                            if (q_magnitude < minimum_magnitude)
                                minimum_magnitude = q_magnitude;

                            if (q_ref[j] < 0)
                                sign_parity = sign_parity ^ 1;
                        end
                    end

                    if (sign_parity == 1)
                        r_value = -minimum_magnitude;
                    else
                        r_value = minimum_magnitude;

                    r_value = sat8(r_value);

                    // Layered variable-node update
                    l_value = sat8(q_ref[e] + r_value);

                    idx = k * DEGREE + e;

                    expected_llr_addr[idx] =
                        ref_col_table[e] * 384 +
                        ((k + ref_shift_table[e]) % ZC_TEST);

                    expected_edge_addr[idx] =
                        ref_edge_table[e] * 384 + k;

                    expected_llr_data[idx] = l_value;
                    expected_edge_data[idx] = r_value;

                    golden_checks = golden_checks + 1;
                end
            end

            $display("Independent BG2 golden model generated.");
            $display("Expected writebacks per memory: %0d",
                golden_checks);
        end
    endtask

    task apply_reset;
        begin
            @(negedge clk);
            rst_n = 0;
            start = 0;

            repeat (4) @(negedge clk);

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
            wait_cycles = 0;

            while (layer_done !== 1'b1 && wait_cycles < 10000) begin
                @(negedge clk);
                wait_cycles = wait_cycles + 1;
            end

            if (layer_done !== 1'b1) begin
                $display("ERROR: BG2 layer processing timeout");
                errors = errors + 1;
            end
            else begin
                $display("BG2 layer completed after %0d cycles",
                    wait_cycles);
            end
        end
    endtask

    // Main test
    initial begin
        errors = 0;
        llr_write_count = 0;
        edge_write_count = 0;
        golden_checks = 0;

        rst_n = 0;
        start = 0;
        bg_select = 1;
        layer_index = 0;
        zc = ZC_TEST;

        ref_bg = 1;
        ref_edge_addr = FIRST_EDGE;
        ref_i_ls = 0;
        ref_zc = ZC_TEST;

        $display("");
        $display("==============================================");
        $display("BLOCK 15C: BG2 SIGNED-DATA VERIFICATION");
        $display("==============================================");

        initialize_memories();
        capture_reference_metadata();
        build_golden_model();

        apply_reset();

        // BG2 layer 0, Zc=8
        bg_select = 1'b1;
        layer_index = 0;
        zc = ZC_TEST;

        #1;

        if (cfg_valid !== 1'b1) begin
            $display("ERROR: Legal BG2 lifting size rejected");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 legal lifting size accepted");

        if (i_ls !== 3'd0) begin
            $display("ERROR: Incorrect BG2 lifting-size index");
            errors = errors + 1;
        end
        else
            $display("PASS: BG2 lifting-size index correct");

        issue_start();
        wait_for_completion();

        @(negedge clk);
        #1;

        $display("");
        $display("==============================================");
        $display("BLOCK 15C RESULTS");
        $display("==============================================");

        $display("Expected LLR writes : %0d", EXPECTED_WRITES);
        $display("Actual LLR writes   : %0d", llr_write_count);

        $display("Expected edge writes: %0d", EXPECTED_WRITES);
        $display("Actual edge writes  : %0d", edge_write_count);

        if (llr_write_count != EXPECTED_WRITES) begin
            $display("ERROR: Incorrect LLR write count");
            errors = errors + 1;
        end
        else
            $display("PASS: LLR write count");

        if (edge_write_count != EXPECTED_WRITES) begin
            $display("ERROR: Incorrect edge write count");
            errors = errors + 1;
        end
        else
            $display("PASS: Edge write count");

        if (busy !== 1'b0) begin
            $display("ERROR: DUT still busy after completion");
            errors = errors + 1;
        end

        if (error !== 1'b0) begin
            $display("ERROR: DUT reported internal processing error");
            errors = errors + 1;
        end

        if (start_error !== 1'b0) begin
            $display("ERROR: DUT reported start error");
            errors = errors + 1;
        end

        $display("Total golden comparisons: %0d", golden_checks);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BLOCK 15C BG2 SIGNED-DATA VERIFICATION");
        else
            $display("FAIL: BLOCK 15C BG2 SIGNED-DATA VERIFICATION");

        $display("==============================================");
        $finish;
    end

    initial begin
        #2000000;
        $display("FATAL: Global simulation timeout");
        $finish;
    end

endmodule
