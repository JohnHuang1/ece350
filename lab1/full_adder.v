module full_adder (
    S, Cout, A, B, Cin
);
    input A, B, Cin;
    output S, Cout;
    wire w1, w2, w3;

    xor s_result(S, A, B, Cin);

    and ab_and(w1, A, B);
    and ac_and(w2, A, Cin);
    and bc_and(w3, B, Cin);

    or c_result(Cout, w1, w2, w3);
endmodule