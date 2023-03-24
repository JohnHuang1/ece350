module counter_mod32 (
    input clock, reset, enable,
    output [5:0] q
);
    wire [7:0] tff_in = {q, 2'b11};
    genvar i;
    generate 
        for(i = 0; i < 6; i = i + 1) begin
            wire toggle = &tff_in[i + 1:0];
            tff tff1(.T(toggle), .clock(clock), .en(enable), .clr(reset), .q(q[i]));
        end
    endgenerate

endmodule