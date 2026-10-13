// 3-Input AND - Structural
module and3_st(a, b, c, out);
    input a, b, c;
    output out;
    wire ab;
    and_gate_bh g1(.a(a),  .b(b), .y(ab));
    and_gate_bh g2(.a(ab), .b(c), .y(out));
endmodule

// 4-Input AND - Structural
module and4_st(a, b, c, d, out);
    input a, b, c, d;
    output out;
    wire ab, cd;
    and_gate_bh g1(.a(a),  .b(b),  .y(ab));
    and_gate_bh g2(.a(c),  .b(d),  .y(cd));
    and_gate_bh g3(.a(ab), .b(cd), .y(out));
endmodule

// 4-Input OR - Structural
module or4_st(a, b, c, d, out);
    input a, b, c, d;
    output out;
    wire ab, cd;
    or_gate_bh g1(.a(a),  .b(b),  .out(ab));
    or_gate_bh g2(.a(c),  .b(d),  .out(cd));
    or_gate_bh g3(.a(ab), .b(cd), .out(out));
endmodule

// 8-Input OR - Structural
module or8_st(a, b, c, d, e, f, g, h, out);
    input a, b, c, d, e, f, g, h;
    output out;
    wire lo, hi;
    or4_st     g1(.a(a), .b(b), .c(c), .d(d), .out(lo));
    or4_st     g2(.a(e), .b(f), .c(g), .d(h), .out(hi));
    or_gate_bh g3(.a(lo), .b(hi), .out(out));
endmodule