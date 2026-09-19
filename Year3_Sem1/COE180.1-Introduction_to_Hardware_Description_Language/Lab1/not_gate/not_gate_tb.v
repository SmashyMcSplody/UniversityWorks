`timescale 1ns / 1ps

module not_gate_tb;
        reg a;
        wire out_df, out_bh, out_st;

        not_gate_df dut_df (
            .a(a),
            .out(out_df)
        );

        not_gate_bh dut_bh (
            .a(a),
            .out(out_bh)
        );

        not_gate_st dut_st (
            .a(a),
            .out(out_st)
        );

        initial begin
            $dumpfile("not_gate_tb.vcd");
            $dumpvars(0, not_gate_tb);
            $monitor("Time=%0t ns | a=%b | out_df=%b out_bh=%b out_st=%b", $time, a, out_df, out_bh, out_st);

            a = 0; #10;
            a = 1; #10;
            
            $finish;
        end
endmodule