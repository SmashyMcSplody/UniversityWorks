// NOT Gate - Dataflow style
module not_gate_df (
    input a,
    output y
);
    assign y = ~a;
endmodule

// NOT Gate - Behavioral style
module not_gate_bh (
    input a,
    output reg y
);
    always @(*) begin
        y = ~a;
    end
endmodule

// NOT Gate - Structural style
module not_gate_st (
    input a,
    output y
);
    not not1 (y, a);
endmodule