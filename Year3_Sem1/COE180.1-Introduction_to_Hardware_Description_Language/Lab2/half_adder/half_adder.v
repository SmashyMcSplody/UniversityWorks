// Half Adder - Dataflow
module half_adder_df (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule

// Half Adder - Behavioral
module half_adder_bh (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic carry
);
    always_comb begin
        sum   = a ^ b;
        carry = a & b;
    end
endmodule

// Half Adder - Structural
// Built using an XOR gate for the sum, an AND gate for the carry
module half_adder_st (
    input  logic a,
    input  logic b,
    output wire  sum,
    output wire  carry
);
    xor (sum, a, b);
    and (carry, a, b);
endmodule