// NOT Gate - Dataflow
module not_gate_df (
    input a,
    output out
);
    assign out = ~a;
endmodule

// NOT Gate - Behavioral
module not_gate_bh (
    input a,
    output reg out
);
    always @(*) begin
        out = ~a;
    end
endmodule

// NOT Gate - Structural
module not_gate_st (
    input a,
    output out
);
    not not1 (out, a);
endmodule