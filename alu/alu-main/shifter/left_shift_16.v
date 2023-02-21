module left_shift_16 (
    input [31:0] in,
    input copyBit,
    output [31:0] out
);
    assign out = {in[15:0], {16{copyBit}}};
endmodule