`timescale 1ns/1ps

// Testbench - 4:1 Multiplexer from 2:1 Multiplexers
module mux4x1_from2x1_tb;
    reg A, B, C, D;
    reg X, Y;
    wire OUT_df, OUT_bh, OUT_st;

    mux4x1_from2x1_df dut_df(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(OUT_df));
    mux4x1_from2x1_bh dut_bh(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(OUT_bh));
    mux4x1_from2x1_st dut_st(.A(A), .B(B), .C(C), .D(D), .X(X), .Y(Y), .OUT(OUT_st));

    initial begin
        $dumpfile("4x1mux_from_2x1mux_tb.vcd");
        $dumpvars(0, mux4x1_from2x1_tb);
        $monitor("t=%0d ns | Y=%b X=%b | A=%b B=%b C=%b D=%b | OUT_df=%b OUT_bh=%b OUT_st=%b",
                 $time, Y, X, A, B, C, D, OUT_df, OUT_bh, OUT_st);

        // pattern 1
        A = 0; B = 1; C = 0; D = 1;
        Y = 0; X = 0; #10;
        Y = 0; X = 1; #10;
        Y = 1; X = 0; #10;
        Y = 1; X = 1; #10;
        // pattern 2 = complement of pattern 1
        A = 1; B = 0; C = 1; D = 0;
        Y = 0; X = 0; #10;
        Y = 0; X = 1; #10;
        Y = 1; X = 0; #10;
        Y = 1; X = 1; #10;

        #10 $finish;
    end
endmodule