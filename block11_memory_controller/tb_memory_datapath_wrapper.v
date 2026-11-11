
`timescale 1ns/1ps

module tb_memory_datapath_wrapper;

    reg clk;
    reg rst_n;
    reg start;
    reg [6:0] base_addr;

    wire busy;
    wire done;
    wire compute_start;

    wire [31:0] L_values;
    wire [31:0] R_old_values;
    wire [31:0] Q_values;
    wire [31:0] R_new_values;
    wire [31:0] L_new_values;

    wire [7:0] min1;
    wire [7:0] min2;

    integer errors;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate complete memory-datapath wrapper
    memory_datapath_wrapper DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .base_addr(base_addr),

        .busy(busy),
        .done(done),
        .compute_start(compute_start),

        .L_values(L_values),
        .R_old_values(R_old_values),
        .Q_values(Q_values),
        .R_new_values(R_new_values),
        .L_new_values(L_new_values),

        .min1(min1),
        .min2(min2)
    );

    // Initialize SRAM
    initial begin
        // Channel LLR values
        DUT.MEM.bank_mem[1][4] = 8'h0A; // L0 = 10
        DUT.MEM.bank_mem[1][5] = 8'h14; // L1 = 20
        DUT.MEM.bank_mem[1][6] = 8'hE2; // L2 = -30
        DUT.MEM.bank_mem[1][7] = 8'h28; // L3 = 40

        // Old check-node messages
        DUT.MEM.bank_mem[1][8]  = 8'h01; // R_old0 = 1
        DUT.MEM.bank_mem[1][9]  = 8'hFE; // R_old1 = -2
        DUT.MEM.bank_mem[1][10] = 8'h03; // R_old2 = 3
        DUT.MEM.bank_mem[1][11] = 8'hFC; // R_old3 = -4
    end

    initial begin

        errors = 0;
        rst_n = 0;
        start = 0;
        base_addr = 7'd20;

        $dumpfile("block11_memory_controller/memory_datapath_wrapper.vcd");
        $dumpvars(0, tb_memory_datapath_wrapper);

        $display("----------------------------------------");
        $display("MEMORY + CNU-VNU DATAPATH INTEGRATION");
        $display("----------------------------------------");

        // Reset
        repeat (2) @(negedge clk);
        rst_n = 1;

        // Start decoding operation
        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait until SRAM reads are complete
        wait(compute_start);
        #1;

        $display("\n--- SRAM READ RESULTS ---");

        $display("L_values     = %h", L_values);
        $display("R_old_values = %h", R_old_values);

        if (L_values !== 32'h28E2140A) begin
            $display("ERROR: LLR read mismatch");
            errors = errors + 1;
        end

        if (R_old_values !== 32'hFC03FE01) begin
            $display("ERROR: Old message read mismatch");
            errors = errors + 1;
        end

        // Check variable-node extrinsic values
        $display("\n--- CNU-VNU COMPUTATION ---");

        $display("Q_values     = %h", Q_values);
        $display("R_new_values = %h", R_new_values);
        $display("L_new_values = %h", L_new_values);
        $display("min1         = %d", min1);
        $display("min2         = %d", min2);

        // Expected Q = L - R_old
        if (Q_values !== 32'h2CDF1609) begin
            $display("ERROR: Q calculation mismatch");
            errors = errors + 1;
        end

        // Expected outgoing CNU messages
        if (R_new_values !== 32'hF709F7EA) begin
            $display("ERROR: CNU output mismatch");
            errors = errors + 1;
        end

        // Expected updated LLR values
        if (L_new_values !== 32'h23E80DF3) begin
            $display("ERROR: VNU output mismatch");
            errors = errors + 1;
        end

        if (min1 !== 8'd9 || min2 !== 8'd22) begin
            $display("ERROR: Minimum magnitude mismatch");
            errors = errors + 1;
        end

        // Wait for memory write-back to finish
        wait(done);
        #1;

        $display("\n--- SRAM WRITE-BACK CHECK ---");

        // Check updated LLR storage
        if (DUT.MEM.bank_mem[1][4] !== 8'hF3)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][5] !== 8'h0D)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][6] !== 8'hE8)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][7] !== 8'h23)
            errors = errors + 1;

        // Check updated check-node message storage
        if (DUT.MEM.bank_mem[1][8] !== 8'hEA)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][9] !== 8'hF7)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][10] !== 8'h09)
            errors = errors + 1;

        if (DUT.MEM.bank_mem[1][11] !== 8'hF7)
            errors = errors + 1;

        $display("Stored L_new = %h",
            {DUT.MEM.bank_mem[1][7],
             DUT.MEM.bank_mem[1][6],
             DUT.MEM.bank_mem[1][5],
             DUT.MEM.bank_mem[1][4]});

        $display("Stored R_new = %h",
            {DUT.MEM.bank_mem[1][11],
             DUT.MEM.bank_mem[1][10],
             DUT.MEM.bank_mem[1][9],
             DUT.MEM.bank_mem[1][8]});

        // Final result
        if (errors == 0) begin
            $display("\nPASS: SRAM read verified.");
            $display("PASS: Q calculation verified.");
            $display("PASS: CNU outputs verified.");
            $display("PASS: VNU outputs verified.");
            $display("PASS: SRAM write-back verified.");

            $display("\nPASS: COMPLETE DATAPATH INTEGRATION VERIFIED.");
        end
        else begin
            $display("\nFAIL: Total errors = %0d", errors);
        end

        $display("----------------------------------------");
        $finish;

    end

endmodule
