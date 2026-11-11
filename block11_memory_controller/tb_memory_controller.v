
`timescale 1ns/1ps

module tb_memory_controller;

    reg clk;
    reg rst_n;
    reg start;
    reg [6:0] base_addr;

    wire busy;
    wire done;
    wire compute_start;

    wire [31:0] L_values;
    wire [31:0] R_old_values;

    wire we_a, we_b;
    wire [6:0] addr_a, addr_b;
    wire [7:0] din_a, din_b;
    wire [7:0] dout_a, dout_b;

    // Fixed datapath results for write-back verification
    reg [31:0] L_new;
    reg [31:0] R_new;

    integer errors;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Memory controller
    memory_controller DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .base_addr(base_addr),
        .busy(busy),
        .done(done),
        .compute_start(compute_start),

        .L_new(L_new),
        .R_new(R_new),

        .L_values(L_values),
        .R_old_values(R_old_values),

        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),

        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Existing dual-port SRAM
    llr_sram MEM (
        .clk(clk),

        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),

        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Initialize SRAM contents
    initial begin
        MEM.bank_mem[1][4]  = 8'h10;
        MEM.bank_mem[1][5]  = 8'h11;
        MEM.bank_mem[1][6]  = 8'h12;
        MEM.bank_mem[1][7]  = 8'h13;

        MEM.bank_mem[1][8]  = 8'h14;
        MEM.bank_mem[1][9]  = 8'h15;
        MEM.bank_mem[1][10] = 8'h16;
        MEM.bank_mem[1][11] = 8'h17;
    end

    initial begin

        errors = 0;
        rst_n = 0;
        start = 0;
        base_addr = 7'd20;

        L_new = 32'hA3A2A1A0;
        R_new = 32'hB3B2B1B0;

        $dumpfile("block11_memory_controller/memory_controller.vcd");
        $dumpvars(0, tb_memory_controller);

        $display("------------------------------------");
        $display("MEMORY CONTROLLER TEST");
        $display("------------------------------------");

        // Apply reset
        repeat (2) @(negedge clk);
        rst_n = 1;

        // Start transaction
        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait for computation phase
        wait(compute_start);

        #1;

        $display("L_values     = %h", L_values);
        $display("R_old_values = %h", R_old_values);

        // Verify eight SRAM reads
        if (L_values !== 32'h13121110) begin
            $display("ERROR: LLR read mismatch");
            errors = errors + 1;
        end

        if (R_old_values !== 32'h17161514) begin
            $display("ERROR: Old message read mismatch");
            errors = errors + 1;
        end

        // Wait for completion
        wait(done);
        #1;

        $display("Checking SRAM write-back...");

        // Verify updated LLRs
        if (MEM.bank_mem[1][4] !== 8'hA0) errors = errors + 1;
        if (MEM.bank_mem[1][5] !== 8'hA1) errors = errors + 1;
        if (MEM.bank_mem[1][6] !== 8'hA2) errors = errors + 1;
        if (MEM.bank_mem[1][7] !== 8'hA3) errors = errors + 1;

        // Verify new check-node messages
        if (MEM.bank_mem[1][8]  !== 8'hB0) errors = errors + 1;
        if (MEM.bank_mem[1][9]  !== 8'hB1) errors = errors + 1;
        if (MEM.bank_mem[1][10] !== 8'hB2) errors = errors + 1;
        if (MEM.bank_mem[1][11] !== 8'hB3) errors = errors + 1;

        if (errors == 0) begin
            $display("PASS: All eight reads verified.");
            $display("PASS: All eight writes verified.");
            $display("PASS: Memory controller verified.");
        end
        else begin
            $display("FAIL: Total errors = %0d", errors);
        end

        $display("------------------------------------");
        $finish;
    end

endmodule
