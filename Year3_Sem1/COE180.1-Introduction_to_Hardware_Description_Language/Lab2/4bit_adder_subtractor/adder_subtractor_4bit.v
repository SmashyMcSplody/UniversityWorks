// 4-bit Adder-Subtractor - Structural
module adder_subtractor_4bit_df (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       ctrl,
    output logic [3:0] result,
    output logic       cout
);
    assign {cout, result} = a + (b ^ {4{ctrl}}) + ctrl;
endmodule

// 4-bit Adder-Subtractor - Behavioral
module adder_subtractor_4bit_bh (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       ctrl,
    output logic [3:0] result,
    output logic       cout
);
    always_comb begin
        {cout, result} = a + (b ^ {4{ctrl}}) + ctrl;
    end
endmodule

// ctrl = 0: result = a + b
// ctrl = 1: result = a - b
// ctrl does two jobs: it flips every bit of b (via the XOR gates), and it
// becomes the +1 feeded into the first full adder's carry-in.
// The 4 full adders are chained, cout of one feeds cin of the next.
// (Requires full_adder.v, which itself requires half_adder.v, at compile time)
module adder_subtractor_4bit_st (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       ctrl,
    output logic [3:0] result,
    output logic       cout
);
    wire  [3:0] b_xor;
    logic [2:0] carry;
 
    // Conditionally invert each bit of b based on ctrl
    xor (b_xor[0], b[0], ctrl);
    xor (b_xor[1], b[1], ctrl);
    xor (b_xor[2], b[2], ctrl);
    xor (b_xor[3], b[3], ctrl);
 
    full_adder_df fa0 (
        .a(a[0]),
        .b(b_xor[0]),
        .cin(ctrl),
        .sum(result[0]),
        .cout(carry[0])
    );
 
    full_adder_df fa1 (
        .a(a[1]),
        .b(b_xor[1]),
        .cin(carry[0]),
        .sum(result[1]),
        .cout(carry[1])
    );
 
    full_adder_df fa2 (
        .a(a[2]),
        .b(b_xor[2]),
        .cin(carry[1]),
        .sum(result[2]),
        .cout(carry[2])
    );
 
    full_adder_df fa3 (
        .a(a[3]),
        .b(b_xor[3]),
        .cin(carry[2]),
        .sum(result[3]),
        .cout(cout)
    );
endmodule