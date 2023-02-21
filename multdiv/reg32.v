`timescale 1ns/100ps
module reg32 (
    input[31:0] data,
    input write_enable, clk, clear,
    output [31:0] out
);
    genvar i;
    generate 
        for(i = 0; i < 32; i = i + 1) begin: ff_loop
            dffe_ref flip_flop(.q(out[i]), .d(data[i]), .clk(clk), .en(write_enable), .clr(clear));
        end
    endgenerate
endmodule