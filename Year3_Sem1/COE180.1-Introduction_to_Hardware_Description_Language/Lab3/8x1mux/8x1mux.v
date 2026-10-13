// 8:1 Multiplexer - Dataflow
module mux8x1_df(A, B, C, D, E, F, G, H, X, Y, Z, OUT);
    input A, B, C, D, E, F, G, H;
    input X, Y, Z;
    output OUT;
    assign OUT = (~Z & ~Y & ~X & A) |
                 (~Z & ~Y &  X & B) |
                 (~Z &  Y & ~X & C) |
                 (~Z &  Y &  X & D) |
                 ( Z & ~Y & ~X & E) |
                 ( Z & ~Y &  X & F) |
                 ( Z &  Y & ~X & G) |
                 ( Z &  Y &  X & H);
endmodule

// 8:1 Multiplexer - Behavioral
module mux8x1_bh(A, B, C, D, E, F, G, H, X, Y, Z, OUT);
    input A, B, C, D, E, F, G, H;
    input X, Y, Z;
    output reg OUT;
    always @(*)
    begin
        case ({Z, Y, X})
            3'b000:  OUT = A;
            3'b001:  OUT = B;
            3'b010:  OUT = C;
            3'b011:  OUT = D;
            3'b100:  OUT = E;
            3'b101:  OUT = F;
            3'b110:  OUT = G;
            3'b111:  OUT = H;
            default: OUT = 1'bx;
        endcase
    end
endmodule

// 8:1 Multiplexer - Structural
module mux8x1_st(A, B, C, D, E, F, G, H, X, Y, Z, OUT);
    input A, B, C, D, E, F, G, H;
    input X, Y, Z;
    output OUT;
    wire nX, nY, nZ;
    wire d0, d1, d2, d3, d4, d5, d6, d7;
    not_gate_bh n1(.a(X), .out(nX));
    not_gate_bh n2(.a(Y), .out(nY));
    not_gate_bh n3(.a(Z), .out(nZ));
    and4_st     a0(.a(A), .b(nZ), .c(nY), .d(nX), .out(d0));
    and4_st     a1(.a(B), .b(nZ), .c(nY), .d(X), .out(d1));
    and4_st     a2(.a(C), .b(nZ), .c(Y), .d(nX), .out(d2));
    and4_st     a3(.a(D), .b(nZ), .c(Y), .d(X), .out(d3));
    and4_st     a4(.a(E), .b(Z), .c(nY), .d(nX), .out(d4));
    and4_st     a5(.a(F), .b(Z), .c(nY), .d(X), .out(d5));
    and4_st     a6(.a(G), .b(Z), .c(Y), .d(nX), .out(d6));
    and4_st     a7(.a(H), .b(Z), .c(Y), .d(X), .out(d7));
    or8_st      o0(.a(d0), .b(d1), .c(d2), .d(d3), .e(d4), .f(d5), .g(d6), .h(d7), .out(OUT));
endmodule