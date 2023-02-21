module left_shift_2 (
    input [31:0] in,
    input copyBit,
    output [31:0] out
);
    assign out = {in[29:0], {2{copyBit}}};
endmodule