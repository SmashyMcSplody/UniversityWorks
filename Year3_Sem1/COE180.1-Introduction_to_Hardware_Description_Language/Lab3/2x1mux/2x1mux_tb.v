`timescale 1ns/1ps

// Testbench - 2:1 Multiplexer
module mux2x1_tb;
    reg A, B;
    reg X;
    wire OUT_df, OUT_bh, OUT_st;

    mux2x1_df dut_df(.A(A), .B(B), .X(X), .OUT(OUT_df));
    mux2x1_bh dut_bh(.A(A), .B(B), .X(X), .OUT(OUT_bh));
    mux2x1_st dut_st(.A(A), .B(B), .X(X), .OUT(OUT_st));

    initial begin
        $dumpfile("2x1mux_tb.vcd");
        $dumpvars(0, mux2x1_tb);
        $monitor("t=%0d ns | X=%b | A=%b B=%b | OUT_df=%b OUT_bh=%b OUT_st=%b",
                 $time, X, A, B, OUT_df, OUT_bh, OUT_st);

        X = 0; B = 0; A = 0; #10;
        X = 0; B = 0; A = 1; #10;
        X = 0; B = 1; A = 0; #10;
        X = 0; B = 1; A = 1; #10;
        X = 1; B = 0; A = 0; #10;
        X = 1; B = 0; A = 1; #10;
        X = 1; B = 1; A = 0; #10;
        X = 1; B = 1; A = 1; #10;

        #10 $finish;
    end
endmodule