`timescale 1 ns / 100ps
module left_shift_32_barrel_tb;

    wire [31:0] in;
    wire [4:0] shiftAmt;
    wire copyBit;
    wire [31:0] out;

    left_shift_32_barrel sl32b(.in(in), .out(out), .shiftAmt(shiftAmt), .copyBit(copyBit));

    integer i = 4325;
    integer b = 0;
    assign in = i[31:0];
    assign shiftAmt = 23;
    assign copyBit = b[0];

    initial begin
        #20
        $display("in:%b, shiftAmt:%b, copyBit:%b -> out:%b", in, shiftAmt, copyBit, out);
        i = ~i;
        #20
        $display("in:%b, shiftAmt:%b, copyBit:%b -> out:%b", in, shiftAmt, copyBit, out);
        b = 1;
        #20
        $display("in:%b, shiftAmt:%b, copyBit:%b -> out:%b", in, shiftAmt, copyBit, out);
    end

endmodule