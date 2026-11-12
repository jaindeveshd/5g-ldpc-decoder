
`timescale 1ns/1ps

module tb_cnu_equivalence;

    reg signed [7:0] L0, L1, L2, L3;
    reg [31:0] messages_in;

    wire signed [7:0] Y0_ref, Y1_ref, Y2_ref, Y3_ref;
    wire [7:0] min1_ref, min2_ref;

    wire [31:0] messages_out;
    wire [7:0] min1_gen, min2_gen;

    integer errors;
    integer tests;
    integer i;

    cnu REF (
        .L0(L0), .L1(L1), .L2(L2), .L3(L3),
        .Y0(Y0_ref), .Y1(Y1_ref),
        .Y2(Y2_ref), .Y3(Y3_ref),
        .min1(min1_ref), .min2(min2_ref)
    );

    generalized_cnu #(
        .MAX_DEGREE(19),
        .DATA_WIDTH(8),
        .DEGREE_WIDTH(5)
    ) DUT (
        .degree(5'd4),
        .messages_in(messages_in),
        .messages_out(messages_out),
        .min1(min1_gen),
        .min2(min2_gen)
    );

    task compare_outputs;
        begin
            #1;
            tests = tests + 1;

            if (
                messages_out[7:0]   !== Y0_ref ||
                messages_out[15:8]  !== Y1_ref ||
                messages_out[23:16] !== Y2_ref ||
                messages_out[31:24] !== Y3_ref ||
                min1_gen !== min1_ref ||
                min2_gen !== min2_ref
            ) begin
                errors = errors + 1;
                $display("ERROR: LLR inputs = %h %h %h %h",
                         L0, L1, L2, L3);
                $display("Reference outputs = %h %h %h %h",
                         Y0_ref, Y1_ref, Y2_ref, Y3_ref);
                $display("Generalized outputs = %h %h %h %h",
                         messages_out[7:0],
                         messages_out[15:8],
                         messages_out[23:16],
                         messages_out[31:24]);
            end
        end
    endtask

    initial begin
        errors = 0;
        tests = 0;

        // Directed corner cases
        L0 = -128; L1 = 127; L2 = 0; L3 = -1;
        messages_in = {L3, L2, L1, L0};
        compare_outputs();

        L0 = 7; L1 = -7; L2 = 7; L3 = -7;
        messages_in = {L3, L2, L1, L0};
        compare_outputs();

        L0 = 0; L1 = 0; L2 = 0; L3 = 0;
        messages_in = {L3, L2, L1, L0};
        compare_outputs();

        // Randomized comparison
        for (i = 0; i < 1000; i = i + 1) begin
            L0 = $random;
            L1 = $random;
            L2 = $random;
            L3 = $random;

            messages_in = {L3, L2, L1, L0};
            compare_outputs();
        end

        $display("--------------------------------------");
        $display("BLOCK 4 vs BLOCK 13A CNU COMPARISON");
        $display("Total comparisons: %0d", tests);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: FOUR-INPUT CNU EQUIVALENCE");
        else
            $display("FAIL: CNU EQUIVALENCE");

        $display("--------------------------------------");
        $finish;
    end

endmodule
