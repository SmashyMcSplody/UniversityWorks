// XNOR Gate - Dataflow
module xnor_gate_df (
    input a,
    input b,
    output out
);
    assign out = ~(a ^ b);
endmodule

// XNOR Gate - Behavioral
module xnor_gate_bh (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a ^ b);
    end
endmodule

// XNOR Gate - Structural
// Built by feeding the output of an XOR Gate to a NOT Gate
module xnor_gate_st (
    input a,
    input b,
    output out
);
    wire xor_out;

    xor x1 (xor_out, a, b);
    not (out, xor_out);
endmodule