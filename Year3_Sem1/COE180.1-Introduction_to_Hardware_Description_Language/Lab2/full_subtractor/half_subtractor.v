// Half Subtractor - Dataflow
module half_subtractor_df (
    input  logic a,
    input  logic b,
    output logic diff,
    output logic bout
);
    assign diff = a ^ b;
    assign bout = ~a & b;
endmodule

// Half Subtractor - Behavioral
module half_subtractor_bh (
    input  logic a,
    input  logic b,
    output logic diff,
    output logic bout
);
    always_comb begin
        diff = a ^ b;
        bout = ~a & b;
    end
endmodule

// Half Subtractor - Structural
// Built using gate primitives: an XOR gate for the difference, and a NOT + AND
// gate pair for the borrow (borrow = NOT(a) AND b)
module half_subtractor_st (
    input  logic a,
    input  logic b,
    output wire  diff,
    output wire  bout
);
    wire a_not;

    xor (diff, a, b);
    not (a_not, a);
    and (bout, a_not, b);
endmodule