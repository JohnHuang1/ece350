module btn_debouncer(input pb,clk,output pb_out);
// Turns 10Mhz clock input into 4 Hz 
wire slow_clk_en;
wire Q1,Q2,Q2_bar,Q0;
clock_enable u1(clk,slow_clk_en);
my_dff_en d0(clk,slow_clk_en,pb,Q0);

my_dff_en d1(clk,slow_clk_en,Q0,Q1);
my_dff_en d2(clk,slow_clk_en,Q1,Q2);
// assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2;
endmodule
// Slow clock enable for debouncing button 
module clock_enable(input Clk_10M,output slow_clk_en);
    reg [26:0]counter=0;
    always @(posedge Clk_10M)
    begin
       counter <= (counter>=24999) ? 0 : counter + 1;
    end
    assign slow_clk_en = (counter == 24999) ? 1'b1 : 1'b0;
endmodule
// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
           Q <= D;
    end
endmodule 