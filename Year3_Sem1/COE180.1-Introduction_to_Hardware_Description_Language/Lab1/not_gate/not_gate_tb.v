`timescale 1ns / 1ps

module not_gate_tb;
        reg a;
        wire y_df, y_bh, y_st;

        not_gate_df dut_df (
            .a(a),
            .y(y_df)
        );

        not_gate_bh dut_bh (
            .a(a),
            .y(y_bh)
        );

        not_gate_st dut_st (
            .a(a),
            .y(y_st)
        );

        initial begin
            $dumpfile("not_gate_tb.vcd");
            $dumpvars(0, not_gate_tb);
            $monitor("Time=%0t ns | a=%b | y=%b", $time, a, y_df);

            a = 0; #10;
            a = 1; #10;
            
            $finish;
        end
endmodule