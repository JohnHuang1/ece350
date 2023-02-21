`timescale 1 ns / 100ps
module mux_32_tb;
    wire [4:0] select;
    wire [31:0] out;
    wire [31:0] 
        in0 = 0,
        in1 = 1,
        in2 = 2,
        in3 = 3,
        in4 = 4,
        in5 = 5,
        in6 = 6,
        in7 = 7,
        in8 = 8,
        in9 = 9,
        in10 = 10,
        in11 = 11,
        in12 = 12,
        in13 = 13,
        in14 = 14,
        in15 = 15,
        in16 = 16,
        in17 = 17,
        in18 = 18,
        in19 = 19,
        in20 = 20,
        in21 = 21,
        in22 = 22,
        in23 = 23,
        in24 = 24,
        in25 = 25,
        in26 = 26,
        in27 = 27,
        in28 = 28,
        in29 = 29,
        in30 = 30,
        in31 = 31;

    mux_32 mux(out, select, 
    in0, in1, in2, in3, in4, in5, in6, in7, 
    in8, in9, in10, in11, in12, in13, in14, in15, 
    in16, in17, in18, in19, in20, in21, in22, in23, 
    in24, in25, in26, in27, in28, in29, in30, in31);

    integer i;
    assign {select} = i[4:0];
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20;
            $display("i:%d select:%b => out:%b", i, select, out);
        end
        $finish;
    end

    initial begin
        $dumpfile("mux_32_tb_wave.vcd");
        $dumpvars(0, mux_32_tb);
    end

endmodule