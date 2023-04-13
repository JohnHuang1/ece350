module mux_2#(parameter BIT_WIDTH = 32) (
    out, select, in0, in1
);
    input select;
    input [BIT_WIDTH-1:0] in0, in1;
    output [BIT_WIDTH-1:0] out;
    assign out = select ? in1 : in0;
endmodule