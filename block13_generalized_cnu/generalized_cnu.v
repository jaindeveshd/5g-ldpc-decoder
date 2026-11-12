
`timescale 1ns/1ps

module generalized_cnu #(
    parameter MAX_DEGREE = 19,
    parameter DATA_WIDTH = 8,
    parameter DEGREE_WIDTH = 5
)(
    input wire [DEGREE_WIDTH-1:0] degree,

    input wire [MAX_DEGREE*DATA_WIDTH-1:0] messages_in,

    output reg [MAX_DEGREE*DATA_WIDTH-1:0] messages_out,

    output reg [DATA_WIDTH-1:0] min1,
    output reg [DATA_WIDTH-1:0] min2
);

    reg [DATA_WIDTH-1:0] magnitude [0:MAX_DEGREE-1];
    reg sign_bit [0:MAX_DEGREE-1];

    reg [DATA_WIDTH-1:0] selected_magnitude;
    reg outgoing_sign;

    integer i;
    integer j;

    always @* begin

        // Default outputs
        messages_out = {MAX_DEGREE*DATA_WIDTH{1'b0}};

        min1 = {DATA_WIDTH{1'b0}};
        min2 = {DATA_WIDTH{1'b0}};

        selected_magnitude = {DATA_WIDTH{1'b0}};
        outgoing_sign = 1'b0;

        // Initialize intermediate arrays
        for (i = 0; i < MAX_DEGREE; i = i + 1) begin
            magnitude[i] = {DATA_WIDTH{1'b0}};
            sign_bit[i] = 1'b0;
        end

        // Process only valid active edges
        if ((degree >= 2) && (degree <= MAX_DEGREE)) begin

            // Step 1: Convert active inputs to sign and magnitude
            for (i = 0; i < MAX_DEGREE; i = i + 1) begin
                if (i < degree) begin
                    sign_bit[i] =
                        messages_in[i*DATA_WIDTH + DATA_WIDTH-1];

                    if (sign_bit[i])
                        magnitude[i] =
                            (~messages_in[i*DATA_WIDTH +: DATA_WIDTH]) + 1'b1;
                    else
                        magnitude[i] =
                            messages_in[i*DATA_WIDTH +: DATA_WIDTH];
                end
            end

            // Step 2: Find the two smallest magnitudes
            min1 = {DATA_WIDTH{1'b1}};
            min2 = {DATA_WIDTH{1'b1}};

            for (i = 0; i < MAX_DEGREE; i = i + 1) begin
                if (i < degree) begin

                    if (magnitude[i] < min1) begin
                        min2 = min1;
                        min1 = magnitude[i];
                    end
                    else if (magnitude[i] < min2) begin
                        min2 = magnitude[i];
                    end

                end
            end

            // Step 3: Generate each outgoing message
            for (i = 0; i < MAX_DEGREE; i = i + 1) begin

                if (i < degree) begin

                    outgoing_sign = 1'b0;

                    // XOR signs of all inputs except input i
                    for (j = 0; j < MAX_DEGREE; j = j + 1) begin
                        if ((j < degree) && (j != i))
                            outgoing_sign =
                                outgoing_sign ^ sign_bit[j];
                    end

                    // Exclude the corresponding input magnitude
                    if (magnitude[i] == min1)
                        selected_magnitude = min2;
                    else
                        selected_magnitude = min1;

                    // Saturating signed output conversion
                    if (outgoing_sign) begin

                        if (selected_magnitude == 8'd128)
                            messages_out[i*DATA_WIDTH +: DATA_WIDTH] = 8'h80;
                        else
                            messages_out[i*DATA_WIDTH +: DATA_WIDTH] =
                                -selected_magnitude;

                    end
                    else begin

                        if (selected_magnitude == 8'd128)
                            messages_out[i*DATA_WIDTH +: DATA_WIDTH] = 8'h7F;
                        else
                            messages_out[i*DATA_WIDTH +: DATA_WIDTH] =
                                selected_magnitude;

                    end

                end
            end
        end
    end

endmodule
