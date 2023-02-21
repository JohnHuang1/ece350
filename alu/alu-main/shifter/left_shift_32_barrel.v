module left_shift_32_barrel (
    input [31:0] in,
    input [4:0] shiftAmt,
    input copyBit,
    output [31:0] out
);

    // Assumes shiftAmt is unsigned 5-bit integer

    // 16 bit shift
    wire[31:0] shift16, mux16;
    left_shift_16 sll16(.out(shift16), .in(in), .copyBit(copyBit));
    mux_2 m16(.out(mux16), .select(shiftAmt[4]), .in0(in), .in1(shift16));

    // 8 bit shift
    wire[31:0] shift8, mux8;
    left_shift_8 sll8(.out(shift8), .in(mux16), .copyBit(copyBit));
    mux_2 m8(.out(mux8), .select(shiftAmt[3]), .in0(mux16), .in1(shift8));

    // 4 bit shift
    wire[31:0] shift4, mux4;
    left_shift_4 sll4(.out(shift4), .in(mux8), .copyBit(copyBit));
    mux_2 m4(.out(mux4), .select(shiftAmt[2]), .in0(mux8), .in1(shift4));
    
    // 2 bit shift
    wire[31:0] shift2, mux2;
    left_shift_2 sll2(.out(shift2), .in(mux4), .copyBit(copyBit));
    mux_2 m2(.out(mux2), .select(shiftAmt[1]), .in0(mux4), .in1(shift2));

    // 1 bit shift
    wire[31:0] shift1, mux1;
    left_shift_1 sll1(.out(shift1), .in(mux2), .copyBit(copyBit));
    mux_2 m1(.out(mux1), .select(shiftAmt[0]), .in0(mux2), .in1(shift1));

    assign out = mux1;

endmodule