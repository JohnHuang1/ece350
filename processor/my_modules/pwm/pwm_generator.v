module pwm_generator #(parameter pwm_bit_width = 8)(
    input clk, en,
    input [pwm_bit_width-1:0] duty_cycle,
    output pwm_out
);
reg[pwm_bit_width-1:0] pwm_counter = 0;

always @(posedge clk) begin
    pwm_counter <= pwm_counter + 1;
end

assign pwm_out = duty_cycle > pwm_counter ? 1'b1 : 1'b0;
    
endmodule