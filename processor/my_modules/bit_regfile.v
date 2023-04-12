module bit_regfile #(
    parameter SIZE = 8
) (
    input [SIZE-1:0] select, 
    input data, enable, clk, clr,
    output [SIZE-1:0] out 
);
    genvar i;
    generate
        for(i = 0; i < SIZE; i = i + 1) begin: bit_reg_loop
            dffe_ref register(.q(out[i]), .d(data), .clk(clk), .en(enable && select[i]), .clr(clr))
        end
    endgenerate
    
endmodule