
`timescale 1ns/1ps

module tb_ldpc_message_memory;

    parameter DATA_WIDTH = 8;
    parameter LLR_ADDR_WIDTH = 15;
    parameter EDGE_ADDR_WIDTH = 18;

    reg clk;
    reg rst_n;

    reg llr_en;
    reg llr_we;
    reg [LLR_ADDR_WIDTH-1:0] llr_addr;
    reg signed [DATA_WIDTH-1:0] llr_din;
    wire signed [DATA_WIDTH-1:0] llr_dout;

    reg edge_en;
    reg edge_we;
    reg [EDGE_ADDR_WIDTH-1:0] edge_addr;
    reg signed [DATA_WIDTH-1:0] edge_din;
    wire signed [DATA_WIDTH-1:0] edge_dout;

    integer total_checks;
    integer total_errors;

    ldpc_message_memory DUT (
        .clk(clk),
        .rst_n(rst_n),

        .llr_en(llr_en),
        .llr_we(llr_we),
        .llr_addr(llr_addr),
        .llr_din(llr_din),
        .llr_dout(llr_dout),

        .edge_en(edge_en),
        .edge_we(edge_we),
        .edge_addr(edge_addr),
        .edge_din(edge_din),
        .edge_dout(edge_dout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ----------------------------------------
    // Write LLR memory
    // ----------------------------------------
    task write_llr;
        input [LLR_ADDR_WIDTH-1:0] address;
        input signed [7:0] data;
        begin
            @(negedge clk);
            llr_en = 1;
            llr_we = 1;
            llr_addr = address;
            llr_din = data;

            @(posedge clk);
            #1;

            llr_en = 0;
            llr_we = 0;
        end
    endtask

    // ----------------------------------------
    // Read LLR memory
    // ----------------------------------------
    task read_llr;
        input [LLR_ADDR_WIDTH-1:0] address;
        input signed [7:0] expected;
        begin
            @(negedge clk);
            llr_en = 1;
            llr_we = 0;
            llr_addr = address;

            @(posedge clk);
            #1;

            total_checks = total_checks + 1;

            if (llr_dout !== expected) begin
                $display(
                    "ERROR LLR: address=%0d expected=%0d actual=%0d",
                    address, expected, llr_dout
                );
                total_errors = total_errors + 1;
            end

            llr_en = 0;
        end
    endtask

    // ----------------------------------------
    // Write edge-message memory
    // ----------------------------------------
    task write_edge;
        input [EDGE_ADDR_WIDTH-1:0] address;
        input signed [7:0] data;
        begin
            @(negedge clk);
            edge_en = 1;
            edge_we = 1;
            edge_addr = address;
            edge_din = data;

            @(posedge clk);
            #1;

            edge_en = 0;
            edge_we = 0;
        end
    endtask

    // ----------------------------------------
    // Read edge-message memory
    // ----------------------------------------
    task read_edge;
        input [EDGE_ADDR_WIDTH-1:0] address;
        input signed [7:0] expected;
        begin
            @(negedge clk);
            edge_en = 1;
            edge_we = 0;
            edge_addr = address;

            @(posedge clk);
            #1;

            total_checks = total_checks + 1;

            if (edge_dout !== expected) begin
                $display(
                    "ERROR EDGE: address=%0d expected=%0d actual=%0d",
                    address, expected, edge_dout
                );
                total_errors = total_errors + 1;
            end

            edge_en = 0;
        end
    endtask

    // ----------------------------------------
    // Main test sequence
    // ----------------------------------------
    initial begin

        rst_n = 0;

        llr_en = 0;
        llr_we = 0;
        llr_addr = 0;
        llr_din = 0;

        edge_en = 0;
        edge_we = 0;
        edge_addr = 0;
        edge_din = 0;

        total_checks = 0;
        total_errors = 0;

        $display("--------------------------------------");
        $display("LDPC MESSAGE MEMORY TEST");
        $display("--------------------------------------");

        // Reset
        repeat (2) @(posedge clk);
        #1;
        rst_n = 1;

        // ------------------------------------
        // TEST 1: LLR memory
        // ------------------------------------
        $display("\nTEST 1: LLR memory");

        write_llr(0, 25);
        write_llr(383, -45);
        write_llr(384, 127);
        write_llr(26111, -128);

        read_llr(0, 25);
        read_llr(383, -45);
        read_llr(384, 127);
        read_llr(26111, -128);

        // ------------------------------------
        // TEST 2: Edge-message memory
        // ------------------------------------
        $display("\nTEST 2: Edge-message memory");

        write_edge(0, -12);
        write_edge(383, 33);
        write_edge(384, -128);
        write_edge(196991, 127);

        read_edge(0, -12);
        read_edge(383, 33);
        read_edge(384, -128);
        read_edge(196991, 127);

        // ------------------------------------
        // TEST 3: Independent memory operation
        // ------------------------------------
        $display("\nTEST 3: Independent memory operation");

        @(negedge clk);
        llr_en = 1;
        llr_we = 1;
        llr_addr = 100;
        llr_din = -55;

        edge_en = 1;
        edge_we = 1;
        edge_addr = 500;
        edge_din = 66;

        @(posedge clk);
        #1;

        llr_en = 0;
        llr_we = 0;
        edge_en = 0;
        edge_we = 0;

        read_llr(100, -55);
        read_edge(500, 66);

        // ------------------------------------
        // TEST 4: Read-first behavior
        // ------------------------------------
        $display("\nTEST 4: Read-first behavior");

        write_llr(200, 10);

        @(negedge clk);
        llr_en = 1;
        llr_we = 1;
        llr_addr = 200;
        llr_din = 50;

        @(posedge clk);
        #1;

        total_checks = total_checks + 1;

        if (llr_dout !== 8'sd10) begin
            $display(
                "ERROR: LLR read-first expected 10, got %0d",
                llr_dout
            );
            total_errors = total_errors + 1;
        end

        llr_en = 0;
        llr_we = 0;

        read_llr(200, 50);

        // ------------------------------------
        // TEST 5: Invalid addresses
        // ------------------------------------
        $display("\nTEST 5: Invalid addresses");

        @(negedge clk);
        llr_en = 1;
        llr_we = 0;
        llr_addr = 26112;

        @(posedge clk);
        #1;

        total_checks = total_checks + 1;

        if (llr_dout !== 8'sd0) begin
            $display("ERROR: Invalid LLR address did not return zero");
            total_errors = total_errors + 1;
        end

        llr_en = 0;

        @(negedge clk);
        edge_en = 1;
        edge_we = 0;
        edge_addr = 196992;

        @(posedge clk);
        #1;

        total_checks = total_checks + 1;

        if (edge_dout !== 8'sd0) begin
            $display("ERROR: Invalid edge address did not return zero");
            total_errors = total_errors + 1;
        end

        edge_en = 0;

        // ------------------------------------
        // Final report
        // ------------------------------------
        $display("\n--------------------------------------");
        $display("MEMORY TEST SUMMARY");
        $display("--------------------------------------");

        $display("Total checks : %0d", total_checks);
        $display("Total errors : %0d", total_errors);

        if (total_errors == 0)
            $display("PASS: LDPC MESSAGE MEMORY");
        else
            $display("FAIL: LDPC MESSAGE MEMORY");

        $display("--------------------------------------");

        $finish;
    end

endmodule
