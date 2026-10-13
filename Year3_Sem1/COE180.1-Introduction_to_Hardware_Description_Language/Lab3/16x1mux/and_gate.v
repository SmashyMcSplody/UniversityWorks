module and_gate_df (
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module and_gate_bh (
    input a,
    input b,
    output reg y
);
    always @(*) begin
        y = a & b;
    end
endmodule

module and_gate_st (
    input a,
    input b,
    output y
);
    and and1 (y, a, b);   // built-in Verilog primitive
endmodule