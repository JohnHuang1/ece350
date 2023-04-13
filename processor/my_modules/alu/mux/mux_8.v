module mux_8 #(parameter BIT_WIDTH = 32) (out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input [BIT_WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [BIT_WIDTH-1:0] out;
    wire [BIT_WIDTH-1:0] w1, w2;

    mux_4#(.BIT_WIDTH(BIT_WIDTH)) m11(w1, select[1:0], in0, in1, in2, in3);
    mux_4#(.BIT_WIDTH(BIT_WIDTH)) m12(w2, select[1:0], in4, in5, in6, in7);
    mux_2#(.BIT_WIDTH(BIT_WIDTH)) m21(out, select[2], w1, w2);
endmodule