module cla32bit(
    Cout, sum, and_32, or_32, a, b, Cin
);
    input [31:0] a, b;
    input Cin;
    output [31:0] sum, and_32, or_32;
    output Cout;

    // bits 7-0
    wire G0, P0;
    wire [7:0] s7_0, g7_0, p7_0;
    cla8bit block0(.G0(G0), .P0(P0), .g7_0(g7_0), .p7_0(p7_0), .sum(s7_0), .c0(Cin), .a(a[7:0]), .b(b[7:0]));

    // Carry in to block 1
    wire c8, P0c0;
    and gate_P0c0(P0c0, P0, Cin);

    or gate_c8(c8, G0, P0c0);

    // bits 15-8
    wire G1, P1;
    wire [7:0] s15_8, g15_8, p15_8;
    cla8bit block1(.G0(G1), .P0(P1), .g7_0(g15_8), .p7_0(p15_8), .sum(s15_8), .c0(c8), .a(a[15:8]), .b(b[15:8]));

    // Carry in to block 2
    wire c16, P1G0, P1P0c0;
    and gate_P1P0c0(P1P0c0, P1, P0, Cin);
    and gate_P1G0(P1G0, P1, G0);

    or gate_c16(c16, G1, P1G0, P1P0c0);

    // bits 23-16
    wire G2, P2;
    wire [7:0] s23_16, g23_16, p23_16;
    cla8bit block2(.G0(G2), .P0(P2), .g7_0(g23_16), .p7_0(p23_16), .sum(s23_16), .c0(c16), .a(a[23:16]), .b(b[23:16]));

    // Carry in to block 3
    wire c24, P2G1, P2P1G0, P2P1P0c0;
    and gate_P2P1P0c0(P2P1P0c0, P2, P1, P0, Cin);
    and gate_P2P1G0(P2P1G0, P2, P1, G0);
    and gate_P2G1(P2G1, P2, G1);

    or gate_c24(c24, G2, P2G1, P2P1G0, P2P1P0c0);

    // bits 31-24
    wire G3, P3;
    wire [7:0] s31_24, g31_24, p31_24;
    cla8bit block3(.G0(G3), .P0(P3), .g7_0(g31_24), .p7_0(p31_24), .sum(s31_24), .c0(c24), .a(a[31:24]), .b(b[31:24]));

    // Overflow bit
    wire P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0;
    and gate_P3P2P1P0c0(P3P2P1P0c0, P3, P2, P1, P0, Cin);
    and gate_P3P2P1G0(P3P2P1G0, P3, P2, P1, G0);
    and gate_P3P2G1(P3P2G1, P3, P2, G1);
    and gate_P3G2(P3G2, P3, G2);

    or gate_Cout(Cout, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0);

    assign sum = {s31_24, s23_16, s15_8, s7_0};
    assign and_32 = {g31_24, g23_16, g15_8, g7_0};
    assign or_32 = {p31_24, p23_16, p15_8, p7_0};

endmodule