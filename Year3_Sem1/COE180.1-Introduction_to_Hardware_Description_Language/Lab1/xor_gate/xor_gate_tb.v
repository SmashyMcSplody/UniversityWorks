`timescale 1ns / 1ps

module xor_gate_tb;
    reg  a, b;
    wire out_df, out_bh, out_st;

    xor_gate_df dut_df (
        .a(a),
        .b(b),
        .out(out_df)
    );

    xor_gate_bh dut_bh (
        .a(a),
        .b(b),
        .out(out_bh)
    );

    xor_gate_st dut_st (
        .a(a),
        .b(b),
        .out(out_st)
    );

    initial begin
        $dumpfile("xor_gate_tb.vcd");
        $dumpvars(0, xor_gate_tb);
        $monitor("Time=%0t ns | a=%b b=%b | out_df=%b out_bh=%b out_st=%b", $time, a, b, out_df, out_bh, out_st);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end
endmodule