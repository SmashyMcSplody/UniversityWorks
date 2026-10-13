// 4:1 Multiplexer from three 2:1 Multiplexers - Dataflow
module mux4x1_from2x1_df(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output OUT;
    wire AB, CD;
    mux2x1_df m0(.A(A),  .B(B),  .X(X), .OUT(AB));    
    mux2x1_df m1(.A(C),  .B(D),  .X(X), .OUT(CD));    
    mux2x1_df m2(.A(AB), .B(CD), .X(Y), .OUT(OUT));   
endmodule

// 4:1 Multiplexer from three 2:1 Multiplexers - Behavioral
module mux4x1_from2x1_bh(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output OUT;
    wire AB, CD;
    mux2x1_bh m0(.A(A),  .B(B),  .X(X), .OUT(AB));    
    mux2x1_bh m1(.A(C),  .B(D),  .X(X), .OUT(CD));    
    mux2x1_bh m2(.A(AB), .B(CD), .X(Y), .OUT(OUT));   
endmodule

// 4:1 Multiplexer from three 2:1 Multiplexers - Structural
module mux4x1_from2x1_st(A, B, C, D, X, Y, OUT);
    input A, B, C, D;
    input X, Y;
    output OUT;
    wire AB, CD;
    mux2x1_st m0(.A(A),  .B(B),  .X(X), .OUT(AB));    
    mux2x1_st m1(.A(C),  .B(D),  .X(X), .OUT(CD));    
    mux2x1_st m2(.A(AB), .B(CD), .X(Y), .OUT(OUT));   
endmodule