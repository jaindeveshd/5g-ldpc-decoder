
`timescale 1ns/1ps

module lifting_size_decoder (
    input  wire [9:0] zc,
    output reg  [2:0] i_ls,
    output reg        valid
);

    always @(*) begin
        valid = 1'b1;
        i_ls  = 3'd0;

        case (zc)

            // Lifting-size set 0
            10'd2, 10'd4, 10'd8, 10'd16,
            10'd32, 10'd64, 10'd128, 10'd256:
                i_ls = 3'd0;

            // Lifting-size set 1
            10'd3, 10'd6, 10'd12, 10'd24,
            10'd48, 10'd96, 10'd192, 10'd384:
                i_ls = 3'd1;

            // Lifting-size set 2
            10'd5, 10'd10, 10'd20, 10'd40,
            10'd80, 10'd160, 10'd320:
                i_ls = 3'd2;

            // Lifting-size set 3
            10'd7, 10'd14, 10'd28, 10'd56,
            10'd112, 10'd224:
                i_ls = 3'd3;

            // Lifting-size set 4
            10'd9, 10'd18, 10'd36, 10'd72,
            10'd144, 10'd288:
                i_ls = 3'd4;

            // Lifting-size set 5
            10'd11, 10'd22, 10'd44, 10'd88,
            10'd176, 10'd352:
                i_ls = 3'd5;

            // Lifting-size set 6
            10'd13, 10'd26, 10'd52, 10'd104,
            10'd208:
                i_ls = 3'd6;

            // Lifting-size set 7
            10'd15, 10'd30, 10'd60, 10'd120,
            10'd240:
                i_ls = 3'd7;

            default: begin
                valid = 1'b0;
                i_ls  = 3'd0;
            end

        endcase
    end

endmodule
