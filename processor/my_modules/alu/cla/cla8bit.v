module cla8bit (
    G0, P0, g7_0, p7_0, sum, c0, a, b
);

    input [7:0] a, b;
    input c0;
    output [7:0] sum, g7_0, p7_0;
    output G0, P0;

    // bit 0
    wire g0, p0, c1, s0;

    and gate_g0(g0, a[0], b[0]);
    or gate_p0(p0, a[0], b[0]);
    xor gate_s0(s0, a[0], b[0], c0);
    
    wire p0c0;
    and gate_p0c0(p0c0, p0, c0);
    or gate_c1(c1, g0, p0c0);

    // bit 1
    wire g1, p1, c2, s1;

    and gate_g1(g1, a[1], b[1]);
    or gate_p1(p1, a[1], b[1]);
    xor gate_s1(s1, a[1], b[1], c1);
    
    wire p1g0, p1p0c0;
    and gate_p1p0c0(p1p0c0, p1, p0, c0);
    and gate_p1g0(p1g0, p1, g0);

    or gate_c2(c2, g1, p1g0, p1p0c0);

    // bit 2
    wire g2, p2, s2;
    and gate_g2(g2, a[2], b[2]);
    or gate_p2(p2, a[2], b[2]);
    xor gate_s2(s2, a[2], b[2], c2);
    
    wire c3, p2g1, p2p1g0, p2p1p0c0;
    and gate_p2p1p0c0(p2p1p0c0, p2, p1, p0, c0);
    and gate_p2p1g0(p2p1g0, p2, p1, g0);
    and gate_p2g1(p2g1, p2, g1);

    or gate_c3(c3, g2, p2g1, p2p1g0, p2p1p0c0);

    // bit 3
    wire g3, p3, s3;
    and gate_g3(g3, a[3], b[3]);
    or gate_p3(p3, a[3], b[3]);
    xor gate_s3(s3, a[3], b[3], c3);
    
    wire c4, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0;
    and gate_p3p2p1p0c0(p3p2p1p0c0, p3, p2, p1, p0, c0);
    and gate_p3p2p1g0(p3p2p1g0, p3, p2, p1, g0);
    and gate_p3p2g1(p3p2g1, p3, p2, g1);
    and gate_p3g2(p3g2, p3, g2);

    or gate_c4(c4, g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);

    // bit 4
    wire g4, p4, s4;
    and gate_g4(g4, a[4], b[4]);
    or gate_p4(p4, a[4], b[4]);
    xor gate_s4(s4, a[4], b[4], c4);
    
    wire c5, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0;
    and gate_p4p3p2p1p0c0(p4p3p2p1p0c0, p4, p3, p2, p1, p0, c0);
    and gate_p4p3p2p1g0(p4p3p2p1g0, p4, p3, p2, p1, g0);
    and gate_p4p3p2g1(p4p3p2g1, p4, p3, p2, g1);
    and gate_p4p3g2(p4p3g2, p4, p3, g2);
    and gate_p4g3(p4g3, p4, g3);

    or gate_c5(c5, g4, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);

    // bit 5
    wire g5, p5, s5;
    and gate_g5(g5, a[5], b[5]);
    or gate_p5(p5, a[5], b[5]);
    xor gate_s5(s5, a[5], b[5], c5);
    
    wire c6, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0;
    and gate_p5p4p3p2p1p0c0(p5p4p3p2p1p0c0, p5, p4, p3, p2, p1, p0, c0);
    and gate_p5p4p3p2p1g0(p5p4p3p2p1g0, p5, p4, p3, p2, p1, g0);
    and gate_p5p4p3p2g1(p5p4p3p2g1, p5, p4, p3, p2, g1);
    and gate_p5p4p3g2(p5p4p3g2, p5, p4, p3, g2);
    and gate_p5p4g3(p5p4g3, p5, p4, g3);
    and gate_p5g4(p5g4, p5, g4);

    or gate_c6(c6, g5, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);

    // bit 6
    wire g6, p6, s6;
    and gate_g6(g6, a[6], b[6]);
    or gate_p6(p6, a[6], b[6]);
    xor gate_s6(s6, a[6], b[6], c6);
    
    wire c7, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0;
    and gate_p6p5p4p3p2p1p0c0(p6p5p4p3p2p1p0c0, p6, p5, p4, p3, p2, p1, p0, c0);
    and gate_p6p5p4p3p2p1g0(p6p5p4p3p2p1g0, p6, p5, p4, p3, p2, p1, g0);
    and gate_p6p5p4p3p2g1(p6p5p4p3p2g1, p6, p5, p4, p3, p2, g1);
    and gate_p6p5p4p3g2(p6p5p4p3g2, p6, p5, p4, p3, g2);
    and gate_p6p5p4g3(p6p5p4g3, p6, p5, p4, g3);
    and gate_p6p5g4(p6p5g4, p6, p5, g4);
    and gate_p6g5(p6g5, p6, g5);

    or gate_c7(c7, g6, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);

    // bit 7
    wire g7, p7, s7;
    and gate_g7(g7, a[7], b[7]);
    or gate_p7(p7, a[7], b[7]);
    xor gate_s7(s7, a[7], b[7], c7);
    
    wire p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0;
    and gate_P0(P0, p7, p6, p5, p4, p3, p2, p1, p0);
    and gate_p7p6p5p4p3p2p1g0(p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);
    and gate_p7p6p5p4p3p2g1(p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
    and gate_p7p6p5p4p3g2(p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
    and gate_p7p6p5p4g3(p7p6p5p4g3, p7, p6, p5, p4, g3);
    and gate_p7p6p5g4(p7p6p5g4, p7, p6, p5, g4);
    and gate_p7p6g5(p7p6g5, p7, p6, g5);
    and gate_p7g6(p7g6, p7, g6);

    or gate_G0(G0, g7, p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0);


    assign sum = {s7, s6, s5, s4, s3, s2, s1, s0};
    assign g7_0 = {g7, g6, g5, g4, g3, g2, g1, g0};
    assign p7_0 = {p7, p6, p5, p4, p3, p2, p1, p0};

endmodule