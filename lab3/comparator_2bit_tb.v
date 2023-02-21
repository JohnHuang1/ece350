`timescale 1 ns / 100ps
module comparator_2bit_tb;

    wire eqp, gtp, eq, gt;
    wire [1:0] A, B;

    comparator_2bit comparator(.eqp(eqp), .gtp(gtp), .A(A), .B(B), .eq(eq), .gt(gt));

    integer i;
    assign {eqp, gtp, A, B} = i[5:0];
    initial begin
        $display("EQ(i+1)\tGT(i+1)\tA\tB|\tEQ(i)\tGT(i)");
        for(i = 0; i < 48; i = i + 1) begin
            #20
            $display("%b\t%b\t%b\t%b=>\t%b\t%b", eqp, gtp, A, B, eq, gt);
        end
        $finish;
    end

endmodule