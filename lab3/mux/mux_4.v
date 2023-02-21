module mux_4(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input in0, in1, in2, in3;
    output out;
    wire w1, w2;

    assign w1 = select[0] ? in1 : in0;
    assign w2 = select[0] ? in3 : in2;
    assign out = select[1] ? w2 : w1;
endmodule