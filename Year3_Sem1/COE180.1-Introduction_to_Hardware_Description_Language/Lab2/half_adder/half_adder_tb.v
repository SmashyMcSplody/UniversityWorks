`timescale 1ns / 1ps

module half_adder_tb;
    logic a, b;
    logic sum_st, carry_st;

    half_adder_st dut_st (
        .a(a),
        .b(b),
        .sum(sum_st),
        .carry(carry_st)
    );

    initial begin
        $dumpfile("half_adder_tb.vcd");
        $dumpvars(0, half_adder_tb);
        $monitor("Time=%0t ns | a=%b b=%b | sum_st=%b carry_st=%b",
                  $time, a, b, sum_st, carry_st);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end
endmodule