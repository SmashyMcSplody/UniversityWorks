// XOR Gate - Dataflow
module xor_gate_df (
    input a,
    input b,
    output out
);
    assign out = a ^ b;   // equivalent to (~a & b) | (a & ~b)
endmodule

// XOR Gate - Behavioral
module xor_gate_bh (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = a ^ b;
    end
endmodule

// XOR Gate - Structural
// Built from 2 NOT Gates with their outputs feeding 1 of the inputs of 2 AND Gates with their outputs feeding both inputs of an OR Gate
module xor_gate_st (
    input a,
    input b,
    output out
);
    wire nota, notb, anda, andb;

    not n1 (nota, a);
    not n2 (notb, b);
    and a1 (andb, a, notb);
    and a2 (anda, b, nota);
    or  o1 (out, anda, andb);
endmodule