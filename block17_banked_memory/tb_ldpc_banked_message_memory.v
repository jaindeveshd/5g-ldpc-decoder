
`timescale 1ns/1ps

module tb_ldpc_banked_message_memory;

    reg clk, rst_n;

    reg llr_en_a, llr_we_a;
    reg [14:0] llr_addr_a;
    reg [7:0] llr_din_a;
    wire [7:0] llr_dout_a;
    wire llr_valid_a;

    reg llr_en_b, llr_we_b;
    reg [14:0] llr_addr_b;
    reg [7:0] llr_din_b;
    wire [7:0] llr_dout_b;
    wire llr_valid_b;

    reg edge_en_a, edge_we_a;
    reg [17:0] edge_addr_a;
    reg [7:0] edge_din_a;
    wire [7:0] edge_dout_a;
    wire edge_valid_a;

    reg edge_en_b, edge_we_b;
    reg [17:0] edge_addr_b;
    reg [7:0] edge_din_b;
    wire [7:0] edge_dout_b;
    wire edge_valid_b;

    integer errors;

    ldpc_banked_message_memory DUT (
        .clk(clk),
        .rst_n(rst_n),

        .llr_en_a(llr_en_a),
        .llr_we_a(llr_we_a),
        .llr_addr_a(llr_addr_a),
        .llr_din_a(llr_din_a),
        .llr_dout_a(llr_dout_a),
        .llr_valid_a(llr_valid_a),

        .llr_en_b(llr_en_b),
        .llr_we_b(llr_we_b),
        .llr_addr_b(llr_addr_b),
        .llr_din_b(llr_din_b),
        .llr_dout_b(llr_dout_b),
        .llr_valid_b(llr_valid_b),

        .edge_en_a(edge_en_a),
        .edge_we_a(edge_we_a),
        .edge_addr_a(edge_addr_a),
        .edge_din_a(edge_din_a),
        .edge_dout_a(edge_dout_a),
        .edge_valid_a(edge_valid_a),

        .edge_en_b(edge_en_b),
        .edge_we_b(edge_we_b),
        .edge_addr_b(edge_addr_b),
        .edge_din_b(edge_din_b),
        .edge_dout_b(edge_dout_b),
        .edge_valid_b(edge_valid_b)
    );

    always #5 clk = ~clk;

    task check;
        input [7:0] actual;
        input [7:0] expected;
        input [255:0] test_name;
        begin
            if (actual !== expected) begin
                $display("FAIL: %0s | Expected=%0h Actual=%0h",
                         test_name, expected, actual);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s", test_name);
            end
        end
    endtask

    initial begin

        clk = 0;
        rst_n = 0;
        errors = 0;

        llr_en_a = 0; llr_we_a = 0;
        llr_addr_a = 0; llr_din_a = 0;

        llr_en_b = 0; llr_we_b = 0;
        llr_addr_b = 0; llr_din_b = 0;

        edge_en_a = 0; edge_we_a = 0;
        edge_addr_a = 0; edge_din_a = 0;

        edge_en_b = 0; edge_we_b = 0;
        edge_addr_b = 0; edge_din_b = 0;

        // Reset
        @(posedge clk);
        #1;

        check(llr_dout_a, 0, "LLR Port A reset");
        check(llr_dout_b, 0, "LLR Port B reset");
        check(edge_dout_a, 0, "Edge Port A reset");
        check(edge_dout_b, 0, "Edge Port B reset");

        rst_n = 1;

        // Write first and last LLR locations simultaneously.
        @(negedge clk);
        llr_en_a = 1; llr_we_a = 1;
        llr_addr_a = 0; llr_din_a = 8'h11;

        llr_en_b = 1; llr_we_b = 1;
        llr_addr_b = 26111; llr_din_b = 8'h22;

        // Write first and last edge locations simultaneously.
        edge_en_a = 1; edge_we_a = 1;
        edge_addr_a = 0; edge_din_a = 8'h33;

        edge_en_b = 1; edge_we_b = 1;
        edge_addr_b = 196991; edge_din_b = 8'h44;

        @(posedge clk);
        #1;

        // Read back all four locations.
        @(negedge clk);
        llr_we_a = 0; llr_addr_a = 0;
        llr_we_b = 0; llr_addr_b = 26111;

        edge_we_a = 0; edge_addr_a = 0;
        edge_we_b = 0; edge_addr_b = 196991;

        @(posedge clk);
        #1;

        check(llr_dout_a, 8'h11, "LLR first address");
        check(llr_dout_b, 8'h22, "LLR final address");
        check(edge_dout_a, 8'h33, "Edge first address");
        check(edge_dout_b, 8'h44, "Edge final address");

        // Check out-of-range addresses.
        @(negedge clk);
        llr_en_a = 1; llr_we_a = 1;
        llr_addr_a = 26112; llr_din_a = 8'hAA;

        edge_en_a = 1; edge_we_a = 1;
        edge_addr_a = 196992; edge_din_a = 8'hBB;

        #1;

        if (llr_valid_a !== 1'b0) begin
            $display("FAIL: LLR invalid address accepted");
            errors = errors + 1;
        end else begin
            $display("PASS: LLR invalid address rejected");
        end

        if (edge_valid_a !== 1'b0) begin
            $display("FAIL: Edge invalid address accepted");
            errors = errors + 1;
        end else begin
            $display("PASS: Edge invalid address rejected");
        end

        @(posedge clk);
        #1;

        // Outputs should retain their previous values.
        check(llr_dout_a, 8'h11, "LLR invalid access preserves output");
        check(edge_dout_a, 8'h33, "Edge invalid access preserves output");

        // Confirm final locations were not corrupted.
        @(negedge clk);
        llr_we_a = 0; llr_addr_a = 26111;
        edge_we_a = 0; edge_addr_a = 196991;

        @(posedge clk);
        #1;

        check(llr_dout_a, 8'h22, "LLR final data preserved");
        check(edge_dout_a, 8'h44, "Edge final data preserved");

        if (errors == 0)
            $display("\nPASS: ALL LDPC BANKED MEMORY TESTS");
        else
            $display("\nFAIL: %0d ERRORS", errors);

        $finish;
    end

endmodule
