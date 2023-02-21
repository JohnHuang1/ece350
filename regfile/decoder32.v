module decoder32(
    input [4:0] select,
    input enable,
    output[31:0] out
);
    assign out = enable << select;
endmodule