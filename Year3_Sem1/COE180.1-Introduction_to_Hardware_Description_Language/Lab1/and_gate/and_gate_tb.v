`timescale 1ns / 1ps

module and_gate_tb;
        reg a, b;
        wire y_df, y_bh, y_st;

        and_gate_df dut_df (
            .a(a),
            .b(b),
            .y(y_df)
        );

        and_gate_bh dut_bh (
            .a(a),
            .b(b),
            .y(y_bh)
        );

        and_gate_st dut_st (
            .a(a),
            .b(b),
            .y(y_st)
        );

        initial begin
            $dumpfile("and_gate_tb.vcd");
            $dumpvars(0, and_gate_tb);
            $monitor("Time=%0t ns | a=%b b=%b | y=%b", $time, a, b, y_df);

            a = 0; b = 0; #10;
            a = 0; b = 1; #10;
            a = 1; b = 0; #10;
            a = 1; b = 1; #10;

            $finish;
        end
endmodule