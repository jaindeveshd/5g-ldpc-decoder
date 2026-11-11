module cnu (
    input  wire signed [7:0] L0,
    input  wire signed [7:0] L1,
    input  wire signed [7:0] L2,
    input  wire signed [7:0] L3,

    output reg  signed [7:0] Y0,
    output reg  signed [7:0] Y1,
    output reg  signed [7:0] Y2,
    output reg  signed [7:0] Y3,

    output reg  [7:0] min1,
    output reg  [7:0] min2
);

    reg [7:0] mag0, mag1, mag2, mag3;
    reg [7:0] out_mag;
    reg sign0, sign1, sign2, sign3;

    always @* begin
        // Step 1: Separate signs and magnitudes.
        sign0 = L0[7];
        sign1 = L1[7];
        sign2 = L2[7];
        sign3 = L3[7];

        mag0 = sign0 ? (~L0[7:0] + 8'd1) : L0[7:0];
        mag1 = sign1 ? (~L1[7:0] + 8'd1) : L1[7:0];
        mag2 = sign2 ? (~L2[7:0] + 8'd1) : L2[7:0];
        mag3 = sign3 ? (~L3[7:0] + 8'd1) : L3[7:0];

        // Step 2: Find the smallest and second-smallest
        // magnitudes. Equal minima are allowed.
        min1 = 8'hFF;
        min2 = 8'hFF;

        if (mag0 < min1) begin
            min2 = min1;
            min1 = mag0;
        end
        else if (mag0 < min2) begin
            min2 = mag0;
        end

        if (mag1 < min1) begin
            min2 = min1;
            min1 = mag1;
        end
        else if (mag1 < min2) begin
            min2 = mag1;
        end

        if (mag2 < min1) begin
            min2 = min1;
            min1 = mag2;
        end
        else if (mag2 < min2) begin
            min2 = mag2;
        end

        if (mag3 < min1) begin
            min2 = min1;
            min1 = mag3;
        end
        else if (mag3 < min2) begin
            min2 = mag3;
        end

        // Step 3: Generate outgoing messages.
        // Exclude the corresponding input when selecting
        // the outgoing magnitude.

        out_mag = (mag0 == min1) ? min2 : min1;
        if (sign1 ^ sign2 ^ sign3)
            Y0 = -$signed(out_mag);
        else if (out_mag == 8'd128)
            Y0 = 8'sh7F;
        else
            Y0 = out_mag[7:0];

        out_mag = (mag1 == min1) ? min2 : min1;
        if (sign0 ^ sign2 ^ sign3)
            Y1 = -$signed(out_mag);
        else if (out_mag == 8'd128)
            Y1 = 8'sh7F;
        else
            Y1 = out_mag[7:0];

        out_mag = (mag2 == min1) ? min2 : min1;
        if (sign0 ^ sign1 ^ sign3)
            Y2 = -$signed(out_mag);
        else if (out_mag == 8'd128)
            Y2 = 8'sh7F;
        else
            Y2 = out_mag[7:0];

        out_mag = (mag3 == min1) ? min2 : min1;
        if (sign0 ^ sign1 ^ sign2)
            Y3 = -$signed(out_mag);
        else if (out_mag == 8'd128)
            Y3 = 8'sh7F;
        else
            Y3 = out_mag[7:0];
    end

endmodule
