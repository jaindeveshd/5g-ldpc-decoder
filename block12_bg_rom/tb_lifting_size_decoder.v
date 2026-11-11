
`timescale 1ns/1ps

module tb_lifting_size_decoder;

    reg  [9:0] zc;
    wire [2:0] i_ls;
    wire       valid;

    integer errors;
    integer i;

    reg [9:0] legal_zc [0:50];
    reg [2:0] expected_ls [0:50];

    lifting_size_decoder DUT (
        .zc(zc),
        .i_ls(i_ls),
        .valid(valid)
    );

    task check_valid;
        input [9:0] test_zc;
        input [2:0] expected_set;
        begin
            zc = test_zc;
            #10;

            if (valid !== 1'b1 || i_ls !== expected_set) begin
                $display(
                    "FAIL: Zc=%0d Expected iLS=%0d, Got valid=%b iLS=%0d",
                    test_zc, expected_set, valid, i_ls
                );
                errors = errors + 1;
            end
        end
    endtask

    task check_invalid;
        input [9:0] test_zc;
        begin
            zc = test_zc;
            #10;

            if (valid !== 1'b0) begin
                $display("FAIL: Invalid Zc=%0d accepted", test_zc);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        zc = 0;

        // iLS = 0
        legal_zc[0]=2;   legal_zc[1]=4;
        legal_zc[2]=8;   legal_zc[3]=16;
        legal_zc[4]=32;  legal_zc[5]=64;
        legal_zc[6]=128; legal_zc[7]=256;

        // iLS = 1
        legal_zc[8]=3;   legal_zc[9]=6;
        legal_zc[10]=12; legal_zc[11]=24;
        legal_zc[12]=48; legal_zc[13]=96;
        legal_zc[14]=192; legal_zc[15]=384;

        // iLS = 2
        legal_zc[16]=5;  legal_zc[17]=10;
        legal_zc[18]=20; legal_zc[19]=40;
        legal_zc[20]=80; legal_zc[21]=160;
        legal_zc[22]=320;

        // iLS = 3
        legal_zc[23]=7;  legal_zc[24]=14;
        legal_zc[25]=28; legal_zc[26]=56;
        legal_zc[27]=112; legal_zc[28]=224;

        // iLS = 4
        legal_zc[29]=9;  legal_zc[30]=18;
        legal_zc[31]=36; legal_zc[32]=72;
        legal_zc[33]=144; legal_zc[34]=288;

        // iLS = 5
        legal_zc[35]=11; legal_zc[36]=22;
        legal_zc[37]=44; legal_zc[38]=88;
        legal_zc[39]=176; legal_zc[40]=352;

        // iLS = 6
        legal_zc[41]=13; legal_zc[42]=26;
        legal_zc[43]=52; legal_zc[44]=104;
        legal_zc[45]=208;

        // iLS = 7
        legal_zc[46]=15; legal_zc[47]=30;
        legal_zc[48]=60; legal_zc[49]=120;
        legal_zc[50]=240;

        // Generate expected iLS values
        for (i=0; i<8; i=i+1)
            expected_ls[i] = 0;

        for (i=8; i<16; i=i+1)
            expected_ls[i] = 1;

        for (i=16; i<23; i=i+1)
            expected_ls[i] = 2;

        for (i=23; i<29; i=i+1)
            expected_ls[i] = 3;

        for (i=29; i<35; i=i+1)
            expected_ls[i] = 4;

        for (i=35; i<41; i=i+1)
            expected_ls[i] = 5;

        for (i=41; i<46; i=i+1)
            expected_ls[i] = 6;

        for (i=46; i<51; i=i+1)
            expected_ls[i] = 7;

        $display("--------------------------------------");
        $display("LIFTING SIZE DECODER TEST");
        $display("--------------------------------------");

        // Test all 51 legal lifting sizes
        for (i=0; i<51; i=i+1)
            check_valid(legal_zc[i], expected_ls[i]);

        // Test invalid lifting sizes
        check_invalid(0);
        check_invalid(1);
        check_invalid(17);
        check_invalid(200);
        check_invalid(385);
        check_invalid(512);

        $display("");
        $display("Legal sizes tested   : 51");
        $display("Invalid sizes tested : 6");
        $display("Total errors         : %0d", errors);

        if (errors == 0)
            $display("PASS: LIFTING SIZE DECODER VERIFIED");
        else
            $display("FAIL: LIFTING SIZE DECODER");

        $display("--------------------------------------");
        $finish;
    end

endmodule

