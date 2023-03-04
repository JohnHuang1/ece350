module left_shift_4 (
    input [31:0] in,
    input copyBit,
    output [31:0] out
);
    assign out = {in[27:0], {4{copyBit}}};
endmodule