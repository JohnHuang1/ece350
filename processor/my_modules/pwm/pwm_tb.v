`timescale 1 ns / 100ps
module pwm_tb;
    reg clk = 0;
    reg[7:0] duty_cycle = 8'b01111111;
    integer cycle_count = 0;
    wire pwm_out;
    pwm_generator pwm_gen(
    .clk(clk), .en(1'b1),
    .duty_cycle(duty_cycle),
    .pwm_out(pwm_out));

    always #1 clk = ~clk;

    always @(posedge pwm_out) begin
        cycle_count = cycle_count + 1;
        if(cycle_count > 10) $finish;
        // #30 
        // duty_cycle <= duty_cycle + 2;
        // if(duty_cycle >= 128) $finish;
    end

    initial begin
        $dumpfile("tb_PWM.vcd");
        $dumpvars(0, pwm_tb);
    end
endmodule