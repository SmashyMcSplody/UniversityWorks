// Full Subtractor - Dataflow
module full_subtractor_df (
    input  logic a,
    input  logic b,
    input  logic bin,
    output logic diff,
    output logic bout
);
    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | (bin & ~(a ^ b));
endmodule

// Full Subtractor - Behavioral
module full_subtractor_bh (
    input  logic a,
    input  logic b,
    input  logic bin,
    output logic diff,
    output logic bout
);
    always_comb begin
        diff = a ^ b ^ bin;
        bout = (~a & b) | (bin & ~(a ^ b));
    end
endmodule

// Full Subtractor - Structural
// Built by cascading two Half Subtractors, the first subtracts b from a, the
// second subtracts bin from that partial difference. The two half subtractors'
// borrow-outs are combined with an OR gate to produce the final bout.
// Since I'm using half adders, half_adder.v is added in the compiler
module full_subtractor_st (
    input  logic a,
    input  logic b,
    input  logic bin,
    output logic diff,
    output wire  bout
);
    logic diff1, borrow1, borrow2;

    half_subtractor_df hs1 (
        .a(a),
        .b(b),
        .diff(diff1),
        .bout(borrow1)
    );

    half_subtractor_df hs2 (
        .a(diff1),
        .b(bin),
        .diff(diff),
        .bout(borrow2)
    );

    or (bout, borrow1, borrow2);
endmodule