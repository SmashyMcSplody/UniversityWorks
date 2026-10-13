// 4:1 Multiplexer - Dataflow
module mux4x1_df(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output OUT;
    assign OUT = (~Y & ~X & A) |
                 (~Y &  X & B) |
                 ( Y & ~X & C) |
                 ( Y &  X & D);
endmodule

// 4:1 Multiplexer - Behavioral
module mux4x1_bh(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output reg OUT;
    always @(*)
    begin
        case ({Y, X})
            2'b00:   OUT = A;
            2'b01:   OUT = B;
            2'b10:   OUT = C;
            2'b11:   OUT = D;
            default: OUT = 1'bx;
        endcase
    end
endmodule

// 4:1 Multiplexer - Structural
module mux4x1_st(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output OUT;
    wire nX, nY;
    wire d0, d1, d2, d3;
    wire o01, o23;
    not_gate_bh n1(.a(X), .out(nX));
    not_gate_bh n2(.a(Y), .out(nY));
    and3_st     a0(.a(A), .b(nY), .c(nX), .out(d0));
    and3_st     a1(.a(B), .b(nY), .c(X),  .out(d1));
    and3_st     a2(.a(C), .b(Y),  .c(nX), .out(d2));
    and3_st     a3(.a(D), .b(Y),  .c(X),  .out(d3));
    or_gate_bh  o0(.a(d0),  .b(d1),  .out(o01));
    or_gate_bh  o1(.a(d2),  .b(d3),  .out(o23));
    or_gate_bh  o2(.a(o01), .b(o23), .out(OUT));
endmodule