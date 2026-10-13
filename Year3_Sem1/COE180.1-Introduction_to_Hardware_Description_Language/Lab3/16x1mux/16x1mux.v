// 16:1 Multiplexer from five 4:1 Multiplexers - Dataflow
module mux16x1_df(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, X, Y, Z, W, OUT);
    input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    input X, Y, Z, W;
    output OUT;
    wire ABCD, EFGH, IJKL, MNOP;
    // first level: four 4:1 MUX driven by Selectors X and Y
    mux4x1_df m0(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(ABCD));
    mux4x1_df m1(.A(E), .B(F), .C(G), .D(H), .X(X), .Y(Y), .OUT(EFGH));
    mux4x1_df m2(.A(I), .B(J), .C(K), .D(L), .X(X), .Y(Y), .OUT(IJKL));
    mux4x1_df m3(.A(M), .B(N), .C(O), .D(P), .X(X), .Y(Y), .OUT(MNOP));
    // last level: one 4:1 MUX driven by Selectors Z and W
    mux4x1_df m4(.A(ABCD), .B(EFGH), .C(IJKL), .D(MNOP), .X(Z), .Y(W), .OUT(OUT));
endmodule

// 16:1 Multiplexer from five 4:1 Multiplexers - Behavioral
module mux16x1_bh(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, X, Y, Z, W, OUT);
    input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    input X, Y, Z, W;
    output OUT;
    wire ABCD, EFGH, IJKL, MNOP;
    // first level: four 4:1 MUX driven by Selectors X and Y
    mux4x1_bh m0(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(ABCD));
    mux4x1_bh m1(.A(E), .B(F), .C(G), .D(H), .X(X), .Y(Y), .OUT(EFGH));
    mux4x1_bh m2(.A(I), .B(J), .C(K), .D(L), .X(X), .Y(Y), .OUT(IJKL));
    mux4x1_bh m3(.A(M), .B(N), .C(O), .D(P), .X(X), .Y(Y), .OUT(MNOP));
    // last level: one 4:1 MUX driven by Selectors Z and W
    mux4x1_bh m4(.A(ABCD), .B(EFGH), .C(IJKL), .D(MNOP), .X(Z), .Y(W), .OUT(OUT));
endmodule

// 16:1 Multiplexer from five 4:1 Multiplexers - Structural
module mux16x1_st(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, X, Y, Z, W, OUT);
    input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    input X, Y, Z, W;
    output OUT;
    wire ABCD, EFGH, IJKL, MNOP;
    // first level: four 4:1 MUX driven by Selectors X and Y
    mux4x1_st m0(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(ABCD));
    mux4x1_st m1(.A(E), .B(F), .C(G), .D(H), .X(X), .Y(Y), .OUT(EFGH));
    mux4x1_st m2(.A(I), .B(J), .C(K), .D(L), .X(X), .Y(Y), .OUT(IJKL));
    mux4x1_st m3(.A(M), .B(N), .C(O), .D(P), .X(X), .Y(Y), .OUT(MNOP));
    // last level: one 4:1 MUX driven by Selectors Z and W
    mux4x1_st m4(.A(ABCD), .B(EFGH), .C(IJKL), .D(MNOP), .X(Z), .Y(W), .OUT(OUT));
endmodule