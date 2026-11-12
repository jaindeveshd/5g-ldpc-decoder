
`timescale 1ns/1ps

module generalized_cnu_vnu_layer #(
    parameter DATA_WIDTH  = 8,
    parameter MAX_DEGREE  = 19,
    parameter DEGREE_WIDTH = 5
)(
    input wire [DEGREE_WIDTH-1:0] degree,

    // Packed input buses: lane 0 occupies the least-significant byte
    input wire [MAX_DEGREE*DATA_WIDTH-1:0] L_values,
    input wire [MAX_DEGREE*DATA_WIDTH-1:0] R_old_values,

    // Intermediate and final outputs
    output wire [MAX_DEGREE*DATA_WIDTH-1:0] Q_values,
    output wire [MAX_DEGREE*DATA_WIDTH-1:0] R_new_values,
    output wire [MAX_DEGREE*DATA_WIDTH-1:0] L_new_values,

    output wire [DATA_WIDTH-1:0] min1,
    output wire [DATA_WIDTH-1:0] min2
);

    wire [MAX_DEGREE*DATA_WIDTH-1:0] q_bus;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] r_bus;
    wire [MAX_DEGREE*DATA_WIDTH-1:0] l_new_bus;

    // Stage 1: Remove old check-node messages
    // Q[i] = saturate(L[i] - R_old[i])

    genvar i;
    generate
        for (i = 0; i < MAX_DEGREE; i = i + 1) begin : GEN_SUB

            sat_addsub SUB (
                .A(L_values[i*DATA_WIDTH +: DATA_WIDTH]),
                .B(R_old_values[i*DATA_WIDTH +: DATA_WIDTH]),
                .sub(1'b1),
                .Y(q_bus[i*DATA_WIDTH +: DATA_WIDTH]),
                .overflow(),
                .cout()
            );

        end
    endgenerate

    // Stage 2: Generalized Check Node Unit
    // Processes only the number of messages specified by degree.

    generalized_cnu #(
        .MAX_DEGREE(MAX_DEGREE),
        .DATA_WIDTH(DATA_WIDTH),
        .DEGREE_WIDTH(DEGREE_WIDTH)
    ) CNU (
        .degree(degree),
        .messages_in(q_bus),
        .messages_out(r_bus),
        .min1(min1),
        .min2(min2)
    );

    // Stage 3: Update variable-node LLRs
    // L_new[i] = saturate(Q[i] + R_new[i])

    generate
        for (i = 0; i < MAX_DEGREE; i = i + 1) begin : GEN_ADD

            sat_addsub ADD (
                .A(q_bus[i*DATA_WIDTH +: DATA_WIDTH]),
                .B(r_bus[i*DATA_WIDTH +: DATA_WIDTH]),
                .sub(1'b0),
                .Y(l_new_bus[i*DATA_WIDTH +: DATA_WIDTH]),
                .overflow(),
                .cout()
            );

        end
    endgenerate

    // Expose intermediate and final results
    assign Q_values     = q_bus;
    assign R_new_values = r_bus;
    assign L_new_values = l_new_bus;

endmodule
