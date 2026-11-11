`timescale 1ns/1ps

module vnu (
    input  wire signed [7:0] L_old,
    input  wire signed [7:0] R_old,
    input  wire signed [7:0] R_new,
    output wire signed [7:0] L_new
);

    wire signed [7:0] Q;
    wire overflow_sub, cout_sub;
    wire overflow_add, cout_add;

    // Saturated subtraction
    sat_addsub SUB (
        .A(L_old),
        .B(R_old),
        .sub(1'b1),
        .Y(Q),
        .overflow(overflow_sub),
        .cout(cout_sub)
    );

    // Saturated addition
    sat_addsub ADD (
        .A(Q),
        .B(R_new),
        .sub(1'b0),
        .Y(L_new),
        .overflow(overflow_add),
        .cout(cout_add)
    );

endmodule
