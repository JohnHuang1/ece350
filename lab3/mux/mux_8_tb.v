`timescale 1 ns / 100ps
module mux_8_tb;
    wire [2:0] select;
    wire out;
    wire 
        in0 = 0,
        in1 = 1,
        in2 = 2,
        in3 = 3,
        in4 = 4,
        in5 = 5,
        in6 = 6,
        in7 = 7;

    mux_8 mux(out, select, 
    in0, in1, in2, in3, in4, in5, in6, in7);

    integer i;
    assign {select} = i[2:0];
    initial begin
        for(i = 0; i < 8; i = i + 1) begin
            #20;
            $display("i:%d select:%b => out:%b", i, select, out);
        end
        $finish;
    end

    // initial begin
    //     $dumpfile("mux_8_tb_wave.vcd");
    //     $dumpvars(0, mux_8_tb);
    // end

endmodule