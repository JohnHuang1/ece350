`timescale 1 ns / 100ps
module dff_tb;
    reg data = 1'b0, clk = 1'b0;
    wire q, q_not;

    dff flip_flop(.data(data), .clk(clk), .q(q), .q_not(q_not));

    initial begin 
        #5
        data = 1'b1;
        $display("data:%b, clk:%b => q:%b, q_not:%b", data, clk, q, q_not);
        #5
        clk = 1'b1;
        #5
        data = 1'b0;
        #5
        clk = 1'b0;
        #5
        clk = 1'b1;
        #5
        data = 1'b1;
        #5
        data = 1'b0;
        #2
        clk = 1'b0;
        #3
        data = 1'b1;
        #5
        $finish;
    end

    initial begin
        $dumpfile("dff_tb_wave.vcd");
        $dumpvars(0, dff_tb);
    end
endmodule