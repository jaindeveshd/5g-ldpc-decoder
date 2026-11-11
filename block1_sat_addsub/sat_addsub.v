
module sat_addsub (
    input  wire signed [7:0] A,
    input  wire signed [7:0] B,
    input  wire              sub,

    output reg  signed [7:0] Y,
    output wire              overflow,
    output wire              cout
);

    wire [7:0] b_mod;
    wire [8:0] raw_ext;
    wire [7:0] raw_result;
    wire       ovf_add;
    wire       ovf_sub;

    // Invert B for subtraction; otherwise, pass B unchanged.
    assign b_mod = B ^ {8{sub}};

    // Extended binary addition.
    assign raw_ext = {1'b0, A} + {1'b0, b_mod} + sub;

    // Extract the ordinary 8-bit result and carry-out.
    assign raw_result = raw_ext[7:0];
    assign cout       = raw_ext[8];

    // Signed overflow detection.
    assign ovf_add =
        ~(A[7] ^ B[7]) & (A[7] ^ raw_result[7]);

    assign ovf_sub =
        (A[7] ^ B[7]) & (A[7] ^ raw_result[7]);

    assign overflow = sub ? ovf_sub : ovf_add;

    // Saturation logic.
    always @* begin
        if (overflow) begin
            if (A[7] == 1'b0)
                Y = 8'sh7F;  // Positive saturation: +127
            else
                Y = 8'sh80;  // Negative saturation: -128
        end
        else begin
            Y = raw_result;
        end
    end

endmodule

