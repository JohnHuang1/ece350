module left_shift_8 (
    input [31:0] in,
    input copyBit,
    output [31:0] out
);
    assign out = {in[23:0], {8{copyBit}}};
endmodule