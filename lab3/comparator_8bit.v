module comparator_8bit (
    input [7:0] A, B,
    input eqp, gtp,
    output eq, gt
);

    wire eq1, gt1;
    comparator_2bit comp1(.eq(eq1), .gt(gt1), .eqp(eqp), .gtp(gtp), .A(A[7:6]), .B(B[7:6]));

    wire eq2, gt2;
    comparator_2bit comp2(.eq(eq2), .gt(gt2), .eqp(eq1), .gtp(gt1), .A(A[5:4]), .B(B[5:4]));
    
    wire eq3, gt3;
    comparator_2bit comp3(.eq(eq3), .gt(gt3), .eqp(eq2), .gtp(gt2), .A(A[3:2]), .B(B[3:2]));
    
    comparator_2bit comp4(.eq(eq), .gt(gt), .eqp(eq3), .gtp(gt3), .A(A[1:0]), .B(B[1:0]));
    
    
endmodule