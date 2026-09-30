`timescale 1ns / 1ps

module full_subtractor_tb;
    logic a, b, bin;
    logic diff_st, bout_st;

    full_subtractor_st dut_st (
        .a(a),
        .b(b),
        .bin(bin),
        .diff(diff_st),
        .bout(bout_st)
    );

    initial begin
        $dumpfile("full_subtractor_tb.vcd");
        $dumpvars(0, full_subtractor_tb);
        $monitor("Time=%0t ns | a=%b b=%b bin=%b | diff_st=%b bout_st=%b",
                  $time, a, b, bin, diff_st, bout_st);

        a = 0; b = 0; bin = 0; #10;
        a = 0; b = 0; bin = 1; #10;
        a = 0; b = 1; bin = 0; #10;
        a = 0; b = 1; bin = 1; #10;
        a = 1; b = 0; bin = 0; #10;
        a = 1; b = 0; bin = 1; #10;
        a = 1; b = 1; bin = 0; #10;
        a = 1; b = 1; bin = 1; #10;

        $finish;
    end
endmodule