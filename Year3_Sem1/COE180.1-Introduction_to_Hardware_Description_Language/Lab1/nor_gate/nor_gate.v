// NOR Gate - Dataflow style
module nor_gate_df (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);
endmodule

// NOR Gate - Behavioral style
module nor_gate_bh (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a | b);
    end
endmodule

// NOR Gate - Structural style
// Built from an OR gate with its output feeding a NOT gate.
module nor_gate_st (
    input a,
    input b,
    output out
);
    wire or_out;

    or or1 (or_out, a, b);
    not not1 (out, or_out);
endmodule