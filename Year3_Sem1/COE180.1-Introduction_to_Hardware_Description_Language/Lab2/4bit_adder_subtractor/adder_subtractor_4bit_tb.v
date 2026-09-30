`timescale 1ns / 1ps

module adder_subtractor_4bit_tb;
    logic [3:0] a, b;
    logic       ctrl;
    logic [3:0] result_df;
    logic       cout_df;
    logic [3:0] result_bh;
    logic       cout_bh;
    logic [3:0] result_st;
    logic       cout_st;

    adder_subtractor_4bit_df dut_df (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result_df),
        .cout(cout_df)
    );

    adder_subtractor_4bit_bh dut_bh (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result_bh),
        .cout(cout_bh)
    );

    adder_subtractor_4bit_st dut_st (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result_st),
        .cout(cout_st)
    );

    initial begin
        $dumpfile("adder_subtractor_4bit_tb.vcd");
        $dumpvars(0, adder_subtractor_4bit_tb);
        $monitor("Time=%0t ns | a=%b b=%b ctrl=%b | result_df=%b cout_df=%b | result_bh=%b cout_bh=%b | result_st=%b cout_st=%b",
                  $time, a, b, ctrl, result_df, cout_df, result_bh, cout_bh, result_st, cout_st);

        // Addition mode (ctrl = 0)
        a = 4'b0011; b = 4'b0001; ctrl = 0; #10; // 3 + 1  = 4
        a = 4'b0111; b = 4'b0110; ctrl = 0; #10; // 7 + 6  = 13
        a = 4'b1111; b = 4'b0001; ctrl = 0; #10; // 15 + 1 = 0, cout = 1 (overflow)

        // Subtraction mode (ctrl = 1)
        a = 4'b0101; b = 4'b0011; ctrl = 1; #10; // 5 - 3 = 2
        a = 4'b0011; b = 4'b0101; ctrl = 1; #10; // 3 - 5 = -2 -> 1110, cout = 0 (borrow occurred)
        a = 4'b1000; b = 4'b1000; ctrl = 1; #10; // 8 - 8 = 0

        $finish;
    end
endmodule