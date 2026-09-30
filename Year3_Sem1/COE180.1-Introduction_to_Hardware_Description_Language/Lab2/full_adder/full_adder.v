// Full Adder - Dataflow
module full_adder_df (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

// Full Adder - Behavioral
module full_adder_bh (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    always_comb begin
        sum  = a ^ b ^ cin;
        cout = (a & b) | (cin & (a ^ b));
    end
endmodule

// Full Adder - Structural
// Built by cascading two Half Adders. the first adds a and b, the second adds
// that partial sum to cin. The two half adders' carry-outs are combined with
// an OR gate to produce the final cout. Since I'm using half adders,
// half_adder.v is added in the compiler
module full_adder_st (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output wire  cout
);
    logic sum1, carry1, carry2;

    half_adder_df ha1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );

    half_adder_df ha2 (
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(carry2)
    );

    or (cout, carry1, carry2);
endmodule