// OR Gate - Dataflow style
module or_gate_df (
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// OR Gate - Behavioral style
module or_gate_bh (
    input a,
    input b,
    output reg y
);
    always @(*) begin
        y = a | b;
    end
endmodule

// OR Gate - Structural style
module or_gate_st (
    input a,
    input b,
    output y
);
    or or1 (y, a, b);
endmodule