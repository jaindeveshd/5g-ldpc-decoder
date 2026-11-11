`timescale 1ns/1ps

module tb_cnu_wave;

    reg signed [7:0] L0, L1, L2, L3;

    wire signed [7:0] Y0, Y1, Y2, Y3;
    wire [7:0] min1, min2;

    cnu dut (
        .L0(L0), .L1(L1), .L2(L2), .L3(L3),
        .Y0(Y0), .Y1(Y1), .Y2(Y2), .Y3(Y3),
        .min1(min1), .min2(min2)
    );

    initial begin
        $dumpfile("cnu_wave.vcd");
        $dumpvars(0, tb_cnu_wave);

        // Test 1: All positive
        L0 = 3; L1 = 5; L2 = 7; L3 = 9;
        #10;

        // Test 2: Mixed signs
        L0 = -2; L1 = 4; L2 = -6; L3 = 8;
        #10;

        // Test 3: Equal minimum magnitudes
        L0 = 3; L1 = -3; L2 = 5; L3 = 7;
        #10;

        // Test 4: Zero input
        L0 = 0; L1 = 4; L2 = -6; L3 = 8;
        #10;

        // Test 5: Most-negative signed input
        L0 = -128; L1 = 4; L2 = -6; L3 = 8;
        #10;

        $finish;
    end

endmodule
