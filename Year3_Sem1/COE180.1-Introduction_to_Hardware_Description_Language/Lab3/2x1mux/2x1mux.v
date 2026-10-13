// 2:1 Multiplexer - Dataflow
module mux2x1_df(A, B, X, OUT);
    input A, B, X;
    output OUT;
    assign OUT = (A & ~X) | (B & X);
endmodule

// 2:1 Multiplexer - Behavioral
module mux2x1_bh(A, B, X, OUT);
    input A, B, X;
    output reg OUT;
    always @(*)
    begin
        if (X == 1'b0) OUT = A;
        else           OUT = B;
    end
endmodule

// 2:1 Multiplexer - Structural
module mux2x1_st(A, B, X, OUT);
    input A, B, X;
    output OUT;
    wire nX, tA, tB;
    not_gate_bh n1(.a(X),  .out(nX));
    and_gate_bh g1(.a(A),  .b(nX), .y(tA));
    and_gate_bh g2(.a(B),  .b(X),  .y(tB));
    or_gate_bh  g3(.a(tA), .b(tB), .out(OUT));
endmodule