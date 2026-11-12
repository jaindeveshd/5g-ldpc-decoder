
`timescale 1ns/1ps

module tb_generalized_cnu;

    localparam MAX_DEGREE = 19;
    localparam DATA_WIDTH = 8;

    reg [4:0] degree;
    reg [MAX_DEGREE*DATA_WIDTH-1:0] messages_in;

    wire [MAX_DEGREE*DATA_WIDTH-1:0] messages_out;
    wire [7:0] min1;
    wire [7:0] min2;

    integer errors;
    integer tests;

    generalized_cnu #(
        .MAX_DEGREE(MAX_DEGREE),
        .DATA_WIDTH(DATA_WIDTH),
        .DEGREE_WIDTH(5)
    ) DUT (
        .degree(degree),
        .messages_in(messages_in),
        .messages_out(messages_out),
        .min1(min1),
        .min2(min2)
    );

    task check_case;
        input integer degree_in;
        input integer pattern;

        integer i;
        integer value;
        integer magnitude_value;
        integer min1_ref;
        integer min2_ref;
        integer selected_magnitude;
        integer outgoing_sign;

        integer magnitudes [0:MAX_DEGREE-1];
        integer signs [0:MAX_DEGREE-1];

        reg [7:0] expected [0:MAX_DEGREE-1];

        begin
            messages_in = 0;
            degree = degree_in;

            // Generate test input messages
            for (i = 0; i < MAX_DEGREE; i = i + 1) begin

                value = 0;

                if (i < degree_in) begin
                    case (pattern)

                        0: value = ((i * 37 + degree_in * 11) % 255) - 127;

                        1: begin
                            case (i % 5)
                                0: value = -128;
                                1: value = 127;
                                2: value = 0;
                                3: value = -1;
                                4: value = 1;
                            endcase
                        end

                        2: value = (i % 2) ? -7 : 7;

                        3: value = ((i * 13) % 31) - 15;

                        default: value = 0;

                    endcase
                end

                messages_in[i*8 +: 8] = value[7:0];

                signs[i] = (value < 0);

                if (value < 0)
                    magnitudes[i] = -value;
                else
                    magnitudes[i] = value;

                expected[i] = 8'd0;
            end

            #1;

            // Reference minimum calculation
            min1_ref = 255;
            min2_ref = 255;

            for (i = 0; i < degree_in; i = i + 1) begin
                if (magnitudes[i] < min1_ref) begin
                    min2_ref = min1_ref;
                    min1_ref = magnitudes[i];
                end
                else if (magnitudes[i] < min2_ref) begin
                    min2_ref = magnitudes[i];
                end
            end

            // Reference outgoing message calculation
            for (i = 0; i < degree_in; i = i + 1) begin

                outgoing_sign = 0;

                for (integer j = 0; j < degree_in; j = j + 1) begin
                    if (j != i)
                        outgoing_sign = outgoing_sign ^ signs[j];
                end

                if (magnitudes[i] == min1_ref)
                    selected_magnitude = min2_ref;
                else
                    selected_magnitude = min1_ref;

                if (outgoing_sign) begin
                    expected[i] = -selected_magnitude;
                end
                else if (selected_magnitude == 128) begin
                    expected[i] = 8'h7F;
                end
                else begin
                    expected[i] = selected_magnitude;
                end
            end

            // Compare minimum values
            tests = tests + 1;

            if ((min1 !== min1_ref[7:0]) ||
                (min2 !== min2_ref[7:0])) begin

                errors = errors + 1;

                $display(
                    "ERROR: Degree=%0d Pattern=%0d Min1=%0d Expected=%0d Min2=%0d Expected=%0d",
                    degree_in, pattern,
                    min1, min1_ref,
                    min2, min2_ref
                );
            end

            // Compare all active and inactive outputs
            for (i = 0; i < MAX_DEGREE; i = i + 1) begin

                tests = tests + 1;

                if (messages_out[i*8 +: 8] !== expected[i]) begin

                    errors = errors + 1;

                    $display(
                        "ERROR: Degree=%0d Pattern=%0d Output[%0d]=%h Expected=%h",
                        degree_in,
                        pattern,
                        i,
                        messages_out[i*8 +: 8],
                        expected[i]
                    );
                end
            end

        end
    endtask

    initial begin

        errors = 0;
        tests = 0;

        degree = 0;
        messages_in = 0;

        $display("--------------------------------------");
        $display("GENERALIZED CNU VERIFICATION");
        $display("--------------------------------------");

        // Test different base-graph row degrees
        check_case(3, 0);
        check_case(3, 1);
        check_case(3, 2);
        check_case(3, 3);

        check_case(4, 0);
        check_case(4, 1);
        check_case(4, 2);
        check_case(4, 3);

        check_case(10, 0);
        check_case(10, 1);
        check_case(10, 2);
        check_case(10, 3);

        check_case(19, 0);
        check_case(19, 1);
        check_case(19, 2);
        check_case(19, 3);

        $display("--------------------------------------");
        $display("Total checks: %0d", tests);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("PASS: GENERALIZED CNU VERIFIED");
        else
            $display("FAIL: GENERALIZED CNU");

        $display("--------------------------------------");

        $finish;
    end

endmodule
