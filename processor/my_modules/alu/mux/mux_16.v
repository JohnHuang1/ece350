module mux_16 #(parameter BIT_WIDTH = 32) ( 
    input [3:0] select,
    input [BIT_WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15,
    output [BIT_WIDTH-1:0] out);
    wire [BIT_WIDTH-1:0] w1, w2;

    mux_8#(.BIT_WIDTH(BIT_WIDTH)) m11(w1, select[2:0], in0, in1, in2, in3, in4, in5, in6, in7);
    mux_8#(.BIT_WIDTH(BIT_WIDTH)) m12(w2, select[2:0], in8, in9, in10, in11, in12, in13, in14, in15);
    mux_2#(.BIT_WIDTH(BIT_WIDTH)) m21(out, select[3], w1, w2);
endmodule