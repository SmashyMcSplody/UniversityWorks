// NAND Gate - Dataflow
module nand_gate_df (
    input a,
    input b,
    output out
);
    assign out = ~(a & b);
endmodule

// NAND Gate - Behavioral
module nand_gate_bh (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a & b);
    end
endmodule

// NAND Gate - Structural
// Built from an AND gate with its output feeded to a NOT gate
module nand_gate_st (
    input a,
    input b,
    output out
);
    wire and_out;

    and and1 (and_out, a, b); 
    not not1 (out, and_out);    
endmodule