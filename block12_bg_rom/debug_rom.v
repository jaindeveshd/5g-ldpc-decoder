
`timescale 1ns/1ps

module debug_rom;

    reg bg_select;
    reg [9:0] edge_addr;
    reg [2:0] i_ls;
    reg [9:0] zc;

    wire edge_valid;
    wire [5:0] row_index;
    wire [6:0] col_index;
    wire [8:0] shift_value;

    bg_rom dut (
        .bg_select(bg_select),
        .edge_addr(edge_addr),
        .i_ls(i_ls),
        .zc(zc),
        .edge_valid(edge_valid),
        .row_index(row_index),
        .col_index(col_index),
        .shift_value(shift_value)
    );

    initial begin
        bg_select = 1'b0;
        edge_addr = 10'd0;
        i_ls = 3'd0;
        zc = 10'd384;

        #5;

        $display("valid=%b row=%0d col=%0d shift=%0d",
                 edge_valid, row_index, col_index, shift_value);

        if (edge_valid === 1'b1 &&
            row_index === 6'd0 &&
            col_index === 7'd0 &&
            shift_value === 9'd250)
            $display("PASS: ROM first entry verified");
        else
            $display("FAIL: ROM first entry incorrect");

        $finish;
    end

endmodule
