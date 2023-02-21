module reduction_tb();
    integer i = 0;
    wire [2:0] bits;
    assign bits = i[2:0];
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            #20
            $display("reduction of %b is: %b", bits, ~(bits[2] ^ bits[1]) && (bits[0] ^ bits[1]));
        end
        $finish;
    end
endmodule