
`timescale 1ns/1ps

module tb_ldpc_syndrome_checker;

    reg clk;
    reg rst_n;
    reg start;
    reg bg_select;
    reg [9:0] zc;

    wire checker_llr_en;
    wire checker_llr_we;
    wire [14:0] checker_llr_addr;
    wire [7:0] llr_dout;

    wire busy;
    wire done;
    wire syndrome_pass;
    wire error;

    // Testbench memory initialization interface
    reg tb_llr_en;
    reg tb_llr_we;
    reg [14:0] tb_llr_addr;
    reg [7:0] tb_llr_din;

    // Shared LLR memory interface
    wire mem_llr_en;
    wire mem_llr_we;
    wire [14:0] mem_llr_addr;
    wire [7:0] mem_llr_din;

    wire llr_valid;

    integer i;
    integer timeout_count;
    integer errors;

    // Clock: 10 ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Select testbench writes while checker is idle.
    // Select checker reads while it is busy.
    assign mem_llr_en =
        busy ? checker_llr_en : tb_llr_en;

    assign mem_llr_we =
        busy ? checker_llr_we : tb_llr_we;

    assign mem_llr_addr =
        busy ? checker_llr_addr : tb_llr_addr;

    assign mem_llr_din =
        busy ? 8'd0 : tb_llr_din;

    // Syndrome checker
    ldpc_syndrome_checker DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .bg_select(bg_select),
        .zc(zc),

        .llr_en(checker_llr_en),
        .llr_we(checker_llr_we),
        .llr_addr(checker_llr_addr),
        .llr_dout(llr_dout),

        .busy(busy),
        .done(done),
        .syndrome_pass(syndrome_pass),
        .error(error)
    );

    // Actual Block 17 banked memory
    ldpc_banked_message_memory MEMORY (
        .clk(clk),
        .rst_n(rst_n),

        // LLR Port A
        .llr_en_a(mem_llr_en),
        .llr_we_a(mem_llr_we),
        .llr_addr_a(mem_llr_addr),
        .llr_din_a(mem_llr_din),
        .llr_dout_a(llr_dout),
        .llr_valid_a(llr_valid),

        // LLR Port B inactive
        .llr_en_b(1'b0),
        .llr_we_b(1'b0),
        .llr_addr_b(15'd0),
        .llr_din_b(8'd0),
        .llr_dout_b(),
        .llr_valid_b(),

        // Edge Port A inactive
        .edge_en_a(1'b0),
        .edge_we_a(1'b0),
        .edge_addr_a(18'd0),
        .edge_din_a(8'd0),
        .edge_dout_a(),
        .edge_valid_a(),

        // Edge Port B inactive
        .edge_en_b(1'b0),
        .edge_we_b(1'b0),
        .edge_addr_b(18'd0),
        .edge_din_b(8'd0),
        .edge_dout_b(),
        .edge_valid_b()
    );

    // Write one LLR value into the actual banked memory.
    task write_llr;
        input [14:0] address;
        input [7:0] data;
        begin
            @(negedge clk);
            tb_llr_en   = 1'b1;
            tb_llr_we   = 1'b1;
            tb_llr_addr = address;
            tb_llr_din  = data;

            @(negedge clk);
            tb_llr_en = 1'b0;
            tb_llr_we = 1'b0;
        end
    endtask

    // Initialize all LLRs used by a base graph.
    // Address layout: column * 384 + lifted_position.
    task initialize_llrs;
        input integer columns;
        input integer lifting_size;
        input [7:0] data;
        integer c;
        integer j;
        begin
            $display("Initializing %0d columns, Zc=%0d, data=%h",
                     columns, lifting_size, data);

            for (c = 0; c < columns; c = c + 1) begin
                for (j = 0; j < lifting_size; j = j + 1) begin
                    write_llr(c * 384 + j, data);
                end
            end

            @(negedge clk);
            tb_llr_en = 1'b0;
            tb_llr_we = 1'b0;
        end
    endtask

    // Start one complete syndrome check and verify its result.
    task run_syndrome_test;
        input bg;
        input [9:0] lifting_size;
        input expected_pass;
        input [8*32-1:0] test_name;

        begin
            @(negedge clk);
            bg_select = bg;
            zc = lifting_size;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            timeout_count = 0;

            while ((done !== 1'b1) && (timeout_count < 500000)) begin
                @(posedge clk);
                timeout_count = timeout_count + 1;
            end

            #1;

            if (timeout_count >= 500000) begin
                $display("FAIL: %0s - TIMEOUT", test_name);
                errors = errors + 1;
            end
            else if (error !== 1'b0) begin
                $display("FAIL: %0s - ERROR asserted", test_name);
                errors = errors + 1;
            end
            else if (syndrome_pass !== expected_pass) begin
                $display("FAIL: %0s - expected pass=%b, got=%b",
                         test_name, expected_pass, syndrome_pass);
                errors = errors + 1;
            end
            else begin
                $display("PASS: %0s - syndrome_pass=%b",
                         test_name, syndrome_pass);
            end

            @(negedge clk);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        bg_select = 1'b0;
        zc = 10'd2;

        tb_llr_en = 1'b0;
        tb_llr_we = 1'b0;
        tb_llr_addr = 15'd0;
        tb_llr_din = 8'd0;

        errors = 0;

        // Reset
        repeat (4) @(negedge clk);
        rst_n = 1'b1;

        $display("---------------------------------------");
        $display("BLOCK 19B SYNDROME CHECKER TESTBENCH");
        $display("---------------------------------------");

        // TEST 1: BG1 all-zero LLR vector
        initialize_llrs(68, 2, 8'h00);
        run_syndrome_test(
            1'b0, 10'd2, 1'b1, "BG1 all-zero"
        );

        // TEST 2: BG1 single negative LLR
        write_llr(15'd0, 8'hFF);
        run_syndrome_test(
            1'b0, 10'd2, 1'b0, "BG1 single-bit error"
        );

        // TEST 3: BG2 all-zero LLR vector
        initialize_llrs(52, 2, 8'h00);
        run_syndrome_test(
            1'b1, 10'd2, 1'b1, "BG2 all-zero"
        );

        // TEST 4: BG2 single negative LLR
        write_llr(15'd0, 8'hFF);
        run_syndrome_test(
            1'b1, 10'd2, 1'b0, "BG2 single-bit error"
        );

        $display("---------------------------------------");

        if (errors == 0)
            $display("PASS: ALL BLOCK 19B TESTS");
        else
            $display("FAIL: %0d TEST(S) FAILED", errors);

        $display("---------------------------------------");

        $finish;
    end

endmodule
