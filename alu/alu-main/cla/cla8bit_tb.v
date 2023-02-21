`timescale 1 ns / 100ps
module cla8bit_tb;
    wire [7:0] A, B, S;
    wire G0, P0, Cin;
    cla8bit adder(.a(A), .b(B), .c0(Cin), .sum(S), .G0(G0), .P0(P0));

    integer i;
    
    // assign {Cin, A, B} = i[16:0]
    assign B = {i[1:0], {6{1'b0}}};
    assign A = {i[3:2], {6{1'b0}}};
    assign Cin = i[4];

    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20
            $display("A:%b, B:%b, Cin:%b -> S:%b, G0:%b, P0:%b", A, B, Cin, S, G0, P0);
        end
        $finish;
    end

    initial begin
        $dumpfile("cla8bit_tb_wave.vcd");
        $dumpvars(0, cla8bit_tb);
    end

endmodule