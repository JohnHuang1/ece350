module dff(
    input clk, data,
    output q, q_not
);
    wire l1, nClk;

    not not_clk(nClk, clk);

    d_latch latch1(.q(l1), .data(data), .clk(nClk));
    d_latch latch2(.q(q), .q_not(q_not), .data(l1), .clk(clk));

endmodule