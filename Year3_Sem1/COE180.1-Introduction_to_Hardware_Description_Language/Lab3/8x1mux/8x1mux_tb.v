`timescale 1ns/1ps

// Testbench - 8:1 Multiplexer
module mux8x1_tb;
    reg A, B, C, D, E, F, G, H;
    reg X, Y, Z;
    wire OUT_df, OUT_bh, OUT_st;

    mux8x1_df dut_df(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .X(X), .Y(Y), .Z(Z), .OUT(OUT_df));
    mux8x1_bh dut_bh(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .X(X), .Y(Y), .Z(Z), .OUT(OUT_bh));
    mux8x1_st dut_st(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .X(X), .Y(Y), .Z(Z), .OUT(OUT_st));

    initial begin
        $dumpfile("8x1mux_tb.vcd");
        $dumpvars(0, mux8x1_tb);
        $monitor("t=%0d ns | Z=%b Y=%b X=%b | A=%b B=%b C=%b D=%b E=%b F=%b G=%b H=%b | OUT_df=%b OUT_bh=%b OUT_st=%b",
                 $time, Z, Y, X, A, B, C, D, E, F, G, H, OUT_df, OUT_bh, OUT_st);

        // pattern 1
        A = 0; B = 1; C = 1; D = 0;
        E = 0; F = 1; G = 0; H = 1;
        Z = 0; Y = 0; X = 0; #10;
        Z = 0; Y = 0; X = 1; #10;
        Z = 0; Y = 1; X = 0; #10;
        Z = 0; Y = 1; X = 1; #10;
        Z = 1; Y = 0; X = 0; #10;
        Z = 1; Y = 0; X = 1; #10;
        Z = 1; Y = 1; X = 0; #10;
        Z = 1; Y = 1; X = 1; #10;
        // pattern 2 = complement of pattern 1
        A = 1; B = 0; C = 0; D = 1;
        E = 1; F = 0; G = 1; H = 0;
        Z = 0; Y = 0; X = 0; #10;
        Z = 0; Y = 0; X = 1; #10;
        Z = 0; Y = 1; X = 0; #10;
        Z = 0; Y = 1; X = 1; #10;
        Z = 1; Y = 0; X = 0; #10;
        Z = 1; Y = 0; X = 1; #10;
        Z = 1; Y = 1; X = 0; #10;
        Z = 1; Y = 1; X = 1; #10;

        #10 $finish;
    end
endmodule