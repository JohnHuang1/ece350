`timescale 1ns / 1ps
// INPUT
//  1200 = sw[7:0]
//  1201 = sw[15:8]
// OUTPUT
//  1204[15:0] = LED
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut = 0, 
    output wire [31:0] pwm0, pwm1, pwm2, pwm3);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    reg[DATA_WIDTH-1:0] PWMRegArray[0:3];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 0;
        end
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end
    
    always @(negedge clk) begin
        if(wEn) begin
            case (addr)
                12'd1000: PWMRegArray[0] <= dataIn;
                12'd1001: PWMRegArray[1] <= dataIn;
                12'd1002: PWMRegArray[2] <= dataIn;
                12'd1003: PWMRegArray[3] <= dataIn;
                default: MemoryArray[addr] <= dataIn;
            endcase
        end else begin
            case (addr)
                12'd1000: dataOut <= PWMRegArray[0];
                12'd1001: dataOut <= PWMRegArray[1];
                12'd1002: dataOut <= PWMRegArray[2];
                12'd1003: dataOut <= PWMRegArray[3];
                default: dataOut <= MemoryArray[addr];
            endcase
        end
    end

    assign pwm0 = PWMRegArray[0];
    assign pwm1 = PWMRegArray[1];
    assign pwm2 = PWMRegArray[2];
    assign pwm3 = PWMRegArray[3];
endmodule
