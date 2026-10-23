module stimulus;
    reg  [3:0] x;
    wire [6:0] z;

    hexTo7seg delsoc (.hex_input(x), .seven_seg_out(z));

    // Stimulus
    initial begin
        x = 0;
        #20 x = 1;
        #20 x = 2;
        #20 x = 3;
        #20 x = 4;
        #20 x = 5;
        #20 x = 6;
        #20 x = 7;
        #20 x = 8;
        #20 x = 9;
        #20 x = 10;
        #20 x = 11;
        #20 x = 12;
        #20 x = 13;
        #20 x = 14;
        #20 x = 15;
        #20 $stop;          // fixed (see below)
    end
endmodule