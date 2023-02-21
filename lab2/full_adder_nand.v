module full_adder_nand (
    S, Cout, A, B, Cin
);
   input A, B, Cin;
   output S, Cout;
   
   wire AB, ABA, ABB, nAB, nABC, nABCC, nABCA;
   nand nandAB(AB, A, B);
   nand nandABA(ABA, AB, A);
   nand nandABB(ABB, AB, B);
   nand nandnAB(nAB, ABA, ABB);

   nand nandnABC(nABC, nAB, Cin);
   nand nandnABCA(nABCA, nABC, nAB);
   nand nandnABCC(nABCC, nABC, Cin);
   nand nandS(S, nABCA, nABCC);
   nand nandCout(Cout, AB, nABC);
endmodule