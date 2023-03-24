module sr_latch(
    input s, r, clk,
    output q, qn
    );

    wire a = ~(s & clk);
    wire b = ~(r & clk);
    assign q = ~(a & qn);
    assign qn = ~(b & q);

endmodule