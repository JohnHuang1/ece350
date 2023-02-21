module left_shift_1 (
    input [31:0] in,
    input copyBit,
    output [31:0] out
);
    assign out = {in[30:0], {1{copyBit}}};
endmodule