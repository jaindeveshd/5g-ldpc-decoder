
`timescale 1ns/1ps

module tb_generalized_cnu_vnu_layer;

    parameter DATA_WIDTH  = 8;
    parameter MAX_DEGREE  = 19;
    parameter DEGREE_WIDTH = 5;

    reg [DEGREE_WIDTH-1:0] degree;
    reg [MAX_DEGREE*DATA_WIDTH-1:0] L_values;
    reg [MAX_DEGREE*DATA_WIDTH-1:0] R_old_values;

    wire [MAX_DEGREE*DATA_WIDTH-1:0] Q_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] R_new_values;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] L_new_values;

    wire [DATA_WIDTH-1:0] min1;
    wire [DATA_WIDTH-1:0] min2;

    integer total_checks;
    integer total_errors;
    integer test_cases;
    integer random_test_index;

    integer i;
    integer j;

    integer q_ref [0:MAX_DEGREE-1];
    integer r_ref [0:MAX_DEGREE-1];
    integer l_ref [0:MAX_DEGREE-1];
    integer mag [0:MAX_DEGREE-1];

    integer expected_min1;
    integer expected_min2;

    integer sign_xor;
    integer min_a;
    integer min_b;
    integer min_index;

    integer temp_value;
    integer signed_value;

    reg [MAX_DEGREE*DATA_WIDTH-1:0] random_L;
    reg [MAX_DEGREE*DATA_WIDTH-1:0] random_R;

    generalized_cnu_vnu_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_DEGREE(MAX_DEGREE),
        .DEGREE_WIDTH(DEGREE_WIDTH)
    ) DUT (
        .degree(degree),
        .L_values(L_values),
        .R_old_values(R_old_values),
        .Q_values(Q_values),
        .R_new_values(R_new_values),
        .L_new_values(L_new_values),
        .min1(min1),
        .min2(min2)
    );

    // ------------------------------------------------
    // Saturating 8-bit signed arithmetic reference
    // ------------------------------------------------

    function integer sat8;
        input integer value;
        begin
            if (value > 127)
                sat8 = 127;
            else if (value < -128)
                sat8 = -128;
            else
                sat8 = value;
        end
    endfunction

    // ------------------------------------------------
    // Absolute value reference
    // ------------------------------------------------

    function integer abs_value;
        input integer value;
        begin
            if (value < 0)
                abs_value = -value;
            else
                abs_value = value;
        end
    endfunction

    // ------------------------------------------------
    // Independent reference model
    // ------------------------------------------------

    task calculate_reference;
        integer idx;
        integer jdx;
        integer local_sign;
        integer local_min1;
        integer local_min2;
        integer local_min_index;
        integer local_magnitude;
        begin

            local_min1 = 1000;
            local_min2 = 1000;
            local_min_index = -1;

            // Step 1: Q = saturate(L - R_old)
            for (idx = 0; idx < MAX_DEGREE; idx = idx + 1) begin

                if (idx < degree) begin
                    q_ref[idx] = sat8(
                        $signed(L_values[idx*DATA_WIDTH +: DATA_WIDTH])
                        -
                        $signed(R_old_values[idx*DATA_WIDTH +: DATA_WIDTH])
                    );

                    mag[idx] = abs_value(q_ref[idx]);

                    if (mag[idx] < local_min1) begin
                        local_min2 = local_min1;
                        local_min1 = mag[idx];
                        local_min_index = idx;
                    end
                    else if (mag[idx] < local_min2) begin
                        local_min2 = mag[idx];
                    end
                end
                else begin
                    q_ref[idx] = 0;
                    mag[idx] = 0;
                end
            end

            expected_min1 = local_min1;
            expected_min2 = local_min2;

            // Step 2: Calculate outgoing CNU messages
            for (idx = 0; idx < MAX_DEGREE; idx = idx + 1) begin

                if (idx < degree) begin

                    local_sign = 0;

                    for (jdx = 0; jdx < MAX_DEGREE; jdx = jdx + 1) begin
                        if ((jdx < degree) && (jdx != idx)) begin
                            if (q_ref[jdx] < 0)
                                local_sign = local_sign ^ 1;
                        end
                    end

                    // Find minimum magnitude excluding this input
                    if (idx == local_min_index)
                        local_magnitude = local_min2;
                    else
                        local_magnitude = local_min1;

                    // Apply outgoing sign
                    if (local_sign)
                        r_ref[idx] = -local_magnitude;
                    else
                        r_ref[idx] = local_magnitude;

                    // Positive magnitude 128 saturates to +127
                    r_ref[idx] = sat8(r_ref[idx]);

                    // Step 3: L_new = saturate(Q + R_new)
                    l_ref[idx] = sat8(q_ref[idx] + r_ref[idx]);

                end
                else begin
                    r_ref[idx] = 0;
                    l_ref[idx] = 0;
                end
            end
        end
    endtask

    // ------------------------------------------------
    // Run one test case and compare all outputs
    // ------------------------------------------------

    task run_case;
        input integer test_degree;
        input [MAX_DEGREE*DATA_WIDTH-1:0] input_L;
        input [MAX_DEGREE*DATA_WIDTH-1:0] input_R;

        integer lane;
        integer actual_q;
        integer actual_r;
        integer actual_l;

        begin

            degree = test_degree;
            L_values = input_L;
            R_old_values = input_R;

            #10;

            calculate_reference;

            // Check every lane
            for (lane = 0; lane < MAX_DEGREE; lane = lane + 1) begin

                actual_q = $signed(
                    Q_values[lane*DATA_WIDTH +: DATA_WIDTH]
                );

                actual_r = $signed(
                    R_new_values[lane*DATA_WIDTH +: DATA_WIDTH]
                );

                actual_l = $signed(
                    L_new_values[lane*DATA_WIDTH +: DATA_WIDTH]
                );

                total_checks = total_checks + 3;

                if (actual_q !== q_ref[lane]) begin
                    $display(
                        "ERROR: Q lane %0d, degree %0d, expected %0d, got %0d",
                        lane, test_degree, q_ref[lane], actual_q
                    );
                    total_errors = total_errors + 1;
                end

                if (actual_r !== r_ref[lane]) begin
                    $display(
                        "ERROR: R lane %0d, degree %0d, expected %0d, got %0d",
                        lane, test_degree, r_ref[lane], actual_r
                    );
                    total_errors = total_errors + 1;
                end

                if (actual_l !== l_ref[lane]) begin
                    $display(
                        "ERROR: L lane %0d, degree %0d, expected %0d, got %0d",
                        lane, test_degree, l_ref[lane], actual_l
                    );
                    total_errors = total_errors + 1;
                end
            end

            // Check minimum magnitudes
            total_checks = total_checks + 2;

            if (min1 !== expected_min1[7:0]) begin
                $display(
                    "ERROR: min1 expected %0d, got %0d",
                    expected_min1, min1
                );
                total_errors = total_errors + 1;
            end

            if (min2 !== expected_min2[7:0]) begin
                $display(
                    "ERROR: min2 expected %0d, got %0d",
                    expected_min2, min2
                );
                total_errors = total_errors + 1;
            end

            test_cases = test_cases + 1;

        end
    endtask

    // ------------------------------------------------
    // Test sequence
    // ------------------------------------------------

    initial begin

        degree = 0;
        L_values = 0;
        R_old_values = 0;

        total_checks = 0;
        total_errors = 0;
        test_cases = 0;

        random_L = 0;
        random_R = 0;

        $display("----------------------------------------");
        $display("GENERALIZED CNU-VNU DATAPATH TEST");
        $display("----------------------------------------");

        // --------------------------------------------
        // Test 1: Directed tests for each degree
        // --------------------------------------------

        $display("\nTEST 1: Directed tests");

        for (i = 2; i <= 19; i = i + 1) begin

            random_L = 0;
            random_R = 0;

            for (j = 0; j < i; j = j + 1) begin
                random_L[j*8 +: 8] = (j * 7 + 20);
                random_R[j*8 +: 8] = (j * 2 + 3);
            end

            run_case(i, random_L, random_R);

            random_L = 0;
            random_R = 0;

            for (j = 0; j < i; j = j + 1) begin
                random_L[j*8 +: 8] = (j * 5 - 30);
                random_R[j*8 +: 8] = (j * 3 - 10);
            end

            run_case(i, random_L, random_R);

        end

        // --------------------------------------------
        // Test 2: Corner cases
        // --------------------------------------------

        $display("\nTEST 2: Corner cases");

        for (i = 2; i <= 19; i = i + 1) begin

            random_L = 0;
            random_R = 0;

            for (j = 0; j < i; j = j + 1) begin
                case (j % 5)
                    0: random_L[j*8 +: 8] = -128;
                    1: random_L[j*8 +: 8] = 127;
                    2: random_L[j*8 +: 8] = 0;
                    3: random_L[j*8 +: 8] = -1;
                    4: random_L[j*8 +: 8] = 1;
                endcase

                random_R[j*8 +: 8] = 0;
            end

            run_case(i, random_L, random_R);

        end

        // --------------------------------------------
        // Test 3: Randomized tests
        // --------------------------------------------

        $display("\nTEST 3: Randomized tests");

        for (
            random_test_index = 0;
            random_test_index < 100;
            random_test_index = random_test_index + 1
        ) begin

            random_L = 0;
            random_R = 0;

            case (random_test_index % 5)
                0: degree = 2;
                1: degree = 3;
                2: degree = 4;
                3: degree = 10;
                4: degree = 19;
            endcase

            for (j = 0; j < degree; j = j + 1) begin
                random_L[j*8 +: 8] = $random;
                random_R[j*8 +: 8] = $random;
            end

            run_case(degree, random_L, random_R);

        end

        // --------------------------------------------
        // Final report
        // --------------------------------------------

        $display("\n----------------------------------------");
        $display("TEST SUMMARY");
        $display("----------------------------------------");

        $display("Test cases    : %0d", test_cases);
        $display("Total checks  : %0d", total_checks);
        $display("Total errors  : %0d", total_errors);

        if (total_errors == 0)
            $display("PASS: GENERALIZED CNU-VNU DATAPATH");
        else
            $display("FAIL: DATAPATH VERIFICATION");

        $display("----------------------------------------");

        $finish;

    end

endmodule
