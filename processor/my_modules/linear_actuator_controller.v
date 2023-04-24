module linear_actuator_controller (
    input clk, input [31:0] mode, output actuator_pwm
);
reg [27:0] linear_toggle_counter = 0; // 1 hz counter
reg slow_clk = 0; // 1 hz clock
wire [7:0] duty_cycle, auto_duty_cycle;

always @(posedge clk) begin
    if(mode == 32'd2) begin
        linear_toggle_counter <= linear_toggle_counter + 1;
        if(&linear_toggle_counter) begin
            slow_clk <= ~slow_clk;
            // linear_toggle_counter <= 0;
        end
    end
end

assign auto_duty_cycle = slow_clk ? 8'd24 : 8'd12;

assign duty_cycle = mode == 32'd2 ? auto_duty_cycle : (mode == 32'd1 ? 8'd24 : 8'd12);

pwm_generator #(.SLOW_CLOCK_BITS(13)) pwm_gen(.clk(clk), .en(1'b1), .duty_cycle(duty_cycle), .pwm_out(actuator_pwm));

    
endmodule