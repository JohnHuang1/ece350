module comparator_2bit (
    input[1:0] A, B,
    input eqp, gtp,
    output eq, gt
);

    wire [2:0] select = {A[1], A[0], B[1]};

    // Get not of B[0]
    wire b0n;
    not b0not(b0n, B[0]);

    // translate EQ(i) truth table to 8:1 mux
    wire eqm;
    mux_8 eq_mux(.out(eqm), .select(select), 
        .in0(b0n), .in1(1'b0), .in2(B[0]), .in3(1'b0),
        .in4(1'b0), .in5(b0n), .in6(1'b0), .in7(B[0]));

    // output eq
    and eq_and(eq, eqm, eqp);

    // translate GT(i) truth table to 8:1 mux
    wire gtm;
    mux_8 gt_mux(.out(gtm), .select(select), 
    .in0(1'b0), .in1(1'b0), .in2(b0n), .in3(1'b0),
    .in4(1'b1), .in5(1'b0), .in6(1'b1), .in7(b0n));

    wire eqp_and_gtm;
    and eqp_gtm_and(eqp_and_gtm, eqp, gtm);
    or gt_or(gt, gtp, eqp_and_gtm);
endmodule