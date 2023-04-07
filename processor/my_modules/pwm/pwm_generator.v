module pwm_generator #(parameter PWM_BIT_WIDTH = 8, parameter SLOW_CLOCK_BITS = 12)(
    input clk, en,
    input [PWM_BIT_WIDTH-1:0] duty_cycle,
    output pwm_out
);
// Freq of PWM signal = 100Mhz / 2 ^ (PWM_BIT_WIDTH + SLOW_CLOCK_BITS)
// This is when CLK = 10Mhz
reg[PWM_BIT_WIDTH-1:0] pwm_counter = 0;
reg[SLOW_CLOCK_BITS-1:0] slow_clk_counter = 0;
reg slow_clk = 0;

always @(posedge clk) begin
    slow_clk_counter <= slow_clk_counter + 1;
    slow_clk <= &slow_clk_counter;
end

always @(posedge slow_clk) begin
    pwm_counter <= pwm_counter + 1;
end

assign pwm_out = duty_cycle > pwm_counter ? 1'b1 : 1'b0;
    
endmodule