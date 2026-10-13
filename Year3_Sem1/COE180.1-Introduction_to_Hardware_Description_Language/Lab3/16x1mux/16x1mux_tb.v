`timescale 1ns/1ps

// Testbench - 16:1 Multiplexer from 4:1 Multiplexers
module mux16x1_tb;
    reg A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
    reg X, Y, Z, W;
    wire OUT_df, OUT_bh, OUT_st;

    mux16x1_df dut_df(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .I(I), .J(J), .K(K), .L(L), .M(M), .N(N), .O(O), .P(P), .X(X), .Y(Y), .Z(Z), .W(W), .OUT(OUT_df));
    mux16x1_bh dut_bh(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .I(I), .J(J), .K(K), .L(L), .M(M), .N(N), .O(O), .P(P), .X(X), .Y(Y), .Z(Z), .W(W), .OUT(OUT_bh));
    mux16x1_st dut_st(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .I(I), .J(J), .K(K), .L(L), .M(M), .N(N), .O(O), .P(P), .X(X), .Y(Y), .Z(Z), .W(W), .OUT(OUT_st));

    initial begin
        $dumpfile("16x1mux_tb.vcd");
        $dumpvars(0, mux16x1_tb);
        $monitor("t=%0d ns | W=%b Z=%b Y=%b X=%b | A=%b B=%b C=%b D=%b E=%b F=%b G=%b H=%b I=%b J=%b K=%b L=%b M=%b N=%b O=%b P=%b | OUT_df=%b OUT_bh=%b OUT_st=%b",
                 $time, W, Z, Y, X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, OUT_df, OUT_bh, OUT_st);

        // pattern 1
        A = 1; B = 1; C = 0; D = 0;
        E = 0; F = 0; G = 1; H = 1;
        I = 0; J = 1; K = 1; L = 0;
        M = 0; N = 1; O = 0; P = 1;
        W = 0; Z = 0; Y = 0; X = 0; #10;
        W = 0; Z = 0; Y = 0; X = 1; #10;
        W = 0; Z = 0; Y = 1; X = 0; #10;
        W = 0; Z = 0; Y = 1; X = 1; #10;
        W = 0; Z = 1; Y = 0; X = 0; #10;
        W = 0; Z = 1; Y = 0; X = 1; #10;
        W = 0; Z = 1; Y = 1; X = 0; #10;
        W = 0; Z = 1; Y = 1; X = 1; #10;
        W = 1; Z = 0; Y = 0; X = 0; #10;
        W = 1; Z = 0; Y = 0; X = 1; #10;
        W = 1; Z = 0; Y = 1; X = 0; #10;
        W = 1; Z = 0; Y = 1; X = 1; #10;
        W = 1; Z = 1; Y = 0; X = 0; #10;
        W = 1; Z = 1; Y = 0; X = 1; #10;
        W = 1; Z = 1; Y = 1; X = 0; #10;
        W = 1; Z = 1; Y = 1; X = 1; #10;
        // pattern 2 = complement of pattern 1
        A = 0; B = 0; C = 1; D = 1;
        E = 1; F = 1; G = 0; H = 0;
        I = 1; J = 0; K = 0; L = 1;
        M = 1; N = 0; O = 1; P = 0;
        W = 0; Z = 0; Y = 0; X = 0; #10;
        W = 0; Z = 0; Y = 0; X = 1; #10;
        W = 0; Z = 0; Y = 1; X = 0; #10;
        W = 0; Z = 0; Y = 1; X = 1; #10;
        W = 0; Z = 1; Y = 0; X = 0; #10;
        W = 0; Z = 1; Y = 0; X = 1; #10;
        W = 0; Z = 1; Y = 1; X = 0; #10;
        W = 0; Z = 1; Y = 1; X = 1; #10;
        W = 1; Z = 0; Y = 0; X = 0; #10;
        W = 1; Z = 0; Y = 0; X = 1; #10;
        W = 1; Z = 0; Y = 1; X = 0; #10;
        W = 1; Z = 0; Y = 1; X = 1; #10;
        W = 1; Z = 1; Y = 0; X = 0; #10;
        W = 1; Z = 1; Y = 0; X = 1; #10;
        W = 1; Z = 1; Y = 1; X = 0; #10;
        W = 1; Z = 1; Y = 1; X = 1; #10;

        #10 $finish;
    end
endmodule