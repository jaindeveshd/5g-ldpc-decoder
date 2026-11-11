`timescale 1ns/1ps

module tb_barrel_shifter;

    parameter N = 8;
    parameter DATA_WIDTH = 8;

    reg  [N*DATA_WIDTH-1:0] data_in;
    reg  [$clog2(N)-1:0] shift;
    wire [N*DATA_WIDTH-1:0] data_out;

    integer i, s;
    integer errors;

    reg [N*DATA_WIDTH-1:0] expected;

    barrel_shifter #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .data_in(data_in),
        .shift(shift),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("barrel_shifter.vcd");
        $dumpvars(0, tb_barrel_shifter);

        errors = 0;

        // Assign a unique value to each lane
        for (i = 0; i < N; i = i + 1)
            data_in[i*DATA_WIDTH +: DATA_WIDTH] = i + 1;

        $display("--------------------------------");
        $display("BARREL SHIFTER VERIFICATION");
        $display("--------------------------------");

        // Test every possible shift
        for (s = 0; s < N; s = s + 1) begin
            shift = s;
            #10;

            // Calculate expected circular-left rotation
            for (i = 0; i < N; i = i + 1) begin
                expected[i*DATA_WIDTH +: DATA_WIDTH] =
                    data_in[((i+s)%N)*DATA_WIDTH +: DATA_WIDTH];
            end

            if (data_out !== expected) begin
                $display("FAIL: shift=%0d", s);
                $display("Expected: %h", expected);
                $display("Received: %h", data_out);
                errors = errors + 1;
            end
            else begin
                $display("PASS: shift=%0d", s);
            end
        end

        $display("--------------------------------");
        $display("Total shifts tested: %0d", N);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: BARREL SHIFTER VERIFIED");
        else
            $display("FAIL: CHECK RTL");

        $display("--------------------------------");

        $finish;
    end

endmodule
