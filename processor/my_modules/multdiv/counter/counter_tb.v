`timescale 1 ns / 100ps
module counter_tb;
    integer i = 0;
    wire clock = i[0];
    wire [4:0] q;
    reg reset = 0;

    counter_mod32 counter(.clock(clock), .reset(reset), .q(q));

    initial begin
        for(i = 0; i < 65; i = i + 1) begin
            if (i == 46 || i == 48) begin
                assign reset = ~reset;
            end
            #20
            $display("%d | %b | q = %b", i, clock, q);
        end
        $finish;
    end

    initial begin
        $dumpfile("counter_tb_wave.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule