`timescale 1ns / 1ps

module full_adder_tb;
    logic a, b, cin;
    logic sum_st, cout_st;

    full_adder_st dut_st (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum_st),
        .cout(cout_st)
    );

    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);
        $monitor("Time=%0t ns | a=%b b=%b cin=%b | sum_st=%b cout_st=%b",
                  $time, a, b, cin, sum_st, cout_st);

        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;

        $finish;
    end
endmodule