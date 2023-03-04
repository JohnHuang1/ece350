`timescale 1 ns / 100ps
module tff_tb;
    integer i;
    wire clock = i[0];
    wire q;
    wire reset = 0;

    tff tff1(.T(1'b1), .clock(clock), .clr(reset), .q(q), .en(1'b1));

    initial begin
        for(i = 0; i < 10; i = i + 1) begin
            #20
            $display("%d | %b | q = %b", i, clock, q);
        end
        $finish;
    end
endmodule