module compare_select (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [7:0] MIN,
    output wire [7:0] MAX
);

    assign MIN = (A <= B) ? A : B;
    assign MAX = (A <= B) ? B : A;

endmodule

