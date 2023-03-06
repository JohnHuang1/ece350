`timescale 1 ns / 100ps
module decoder32_tb;

    wire [4:0] in;
    wire enable;
    wire [31:0] out;

    decoder32 decoder(.data(in), .out(out), .enable(1'b1));

    integer i = 0;
    assign in = i[4:0];

    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20
            $display("in:%b -> out:%b", in, out);
        end
    end

endmodule