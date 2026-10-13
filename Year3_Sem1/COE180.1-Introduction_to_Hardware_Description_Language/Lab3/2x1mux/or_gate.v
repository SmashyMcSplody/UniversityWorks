// OR Gate - Dataflow
module or_gate_df (
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule

// OR Gate - Behavioral
module or_gate_bh (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = a | b;
    end
endmodule

// OR Gate - Structural
module or_gate_st (
    input a,
    input b,
    output out
);
    or or1 (out, a, b);
endmodule