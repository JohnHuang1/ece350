module d_latch(
    input clk, data,
    output q, q_not
);
    wire set_out, reset_out, data_not;

    not data_n(data_not, data);
    nand set_gate(set_out, data, clk);
    nand reset_gate(reset_out, data_not, clk);

    wire q_wire, qn_wire;

    nand ng1(q_wire, set_out, qn_wire);
    nand ng2(qn_wire, reset_out, q_wire);

    assign q = q_wire;
    assign q_not = qn_wire;

endmodule