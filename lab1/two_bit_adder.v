module two_bit_adder (
    S, Cout, A, B, Cin
);

    input [1:0] A, B;
    input Cin;
    output [1:0] S;
    output Cout;
    wire c0;

    full_adder adder0(S[0], c0, A[0], B[0], Cin);
    full_adder adder1(S[1], Cout, A[1], B[1], c0);
    
endmodule