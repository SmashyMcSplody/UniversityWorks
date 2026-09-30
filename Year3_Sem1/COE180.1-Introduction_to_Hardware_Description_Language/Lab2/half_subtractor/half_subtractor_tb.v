`timescale 1ns / 1ps

module half_subtractor_tb;
    logic a, b;
    logic diff_st, bout_st;

    half_subtractor_st dut_st (
        .a(a),
        .b(b),
        .diff(diff_st),
        .bout(bout_st)
    );

    initial begin
        $dumpfile("half_subtractor_tb.vcd");
        $dumpvars(0, half_subtractor_tb);
        $monitor("Time=%0t ns | a=%b b=%b | diff_st=%b bout_st=%b",
                  $time, a, b, diff_st, bout_st);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end
endmodule