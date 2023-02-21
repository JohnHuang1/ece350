`timescale 1 ns / 100ps
module full_adder_nand_tb;
    reg A, B, Cin;
    wire S, Cout;
    full_adder_nand adder(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

    initial begin
        A = 0;
        B = 0;
        Cin = 0;
        #80;
        $finish;
    end

    always #10 A = ~A;
    always #20 B = ~B;
    always #40 Cin = ~Cin;

    always @(A, B, Cin) begin
        #1
        $display("A:%b, B:%b, Cin:%b -> S:%b, Cout:%b", A, B, Cin, S, Cout);
    end

    initial begin
        $dumpfile("test_adder_nand_tb_wave.vcd");
        $dumpvars(0, full_adder_nand_tb);
    end

endmodule