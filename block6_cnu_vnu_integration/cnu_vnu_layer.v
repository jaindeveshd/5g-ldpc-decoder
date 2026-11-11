`timescale 1ns/1ps

module cnu_vnu_layer (

    input wire signed [7:0] L0,
    input wire signed [7:0] L1,
    input wire signed [7:0] L2,
    input wire signed [7:0] L3,

    input wire signed [7:0] R_old0,
    input wire signed [7:0] R_old1,
    input wire signed [7:0] R_old2,
    input wire signed [7:0] R_old3,

    output wire signed [7:0] Q0,
    output wire signed [7:0] Q1,
    output wire signed [7:0] Q2,
    output wire signed [7:0] Q3,

    output wire signed [7:0] R_new0,
    output wire signed [7:0] R_new1,
    output wire signed [7:0] R_new2,
    output wire signed [7:0] R_new3,

    output wire signed [7:0] L_new0,
    output wire signed [7:0] L_new1,
    output wire signed [7:0] L_new2,
    output wire signed [7:0] L_new3,

    output wire [7:0] min1,
    output wire [7:0] min2
);

    // Stage 1: Remove old check-node messages
    sat_addsub SUB0 (
        .A(L0), .B(R_old0), .sub(1'b1),
        .Y(Q0), .overflow(), .cout()
    );

    sat_addsub SUB1 (
        .A(L1), .B(R_old1), .sub(1'b1),
        .Y(Q1), .overflow(), .cout()
    );

    sat_addsub SUB2 (
        .A(L2), .B(R_old2), .sub(1'b1),
        .Y(Q2), .overflow(), .cout()
    );

    sat_addsub SUB3 (
        .A(L3), .B(R_old3), .sub(1'b1),
        .Y(Q3), .overflow(), .cout()
    );

    // Stage 2: Check Node Unit
    cnu CNU (
        .L0(Q0),
        .L1(Q1),
        .L2(Q2),
        .L3(Q3),

        .Y0(R_new0),
        .Y1(R_new1),
        .Y2(R_new2),
        .Y3(R_new3),

        .min1(min1),
        .min2(min2)
    );

    // Stage 3: Update variable-node LLRs
    sat_addsub ADD0 (
        .A(Q0), .B(R_new0), .sub(1'b0),
        .Y(L_new0), .overflow(), .cout()
    );

    sat_addsub ADD1 (
        .A(Q1), .B(R_new1), .sub(1'b0),
        .Y(L_new1), .overflow(), .cout()
    );

    sat_addsub ADD2 (
        .A(Q2), .B(R_new2), .sub(1'b0),
        .Y(L_new2), .overflow(), .cout()
    );

    sat_addsub ADD3 (
        .A(Q3), .B(R_new3), .sub(1'b0),
        .Y(L_new3), .overflow(), .cout()
    );

endmodule
