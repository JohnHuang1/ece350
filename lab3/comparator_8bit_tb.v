`timescale 1 ns / 100ps
module comparator_8bit_tb;

    wire eqp = 1, gtp = 0;
    wire eq, gt;
    wire [7:0] A, B;

    comparator_8bit comparator(.eqp(eqp), .gtp(gtp), .A(A), .B(B), .eq(eq), .gt(gt));

    integer i;
    assign {A, B} = {2{i[7:0]}};
    initial begin
        $display("A\tB|\tEQ(i)\tGT(i)");
        for(i = 0; i < 256; i = i + 1) begin
            #20
            $display("%b\t%b=>\t%b\t%b", A, B, eq, gt);
        end
        $finish;
    end

endmodule