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
    input [31:0] num1, num2,
    output [15:0] LED);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
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
            MemoryArray[addr] <= dataIn;
        end else begin
            case (addr)
                12'd1200: dataOut <= num1;
                12'd1201: dataOut <= num2;
                default: dataOut <= MemoryArray[addr];
            endcase
        end
    end

    assign LED = MemoryArray[12'd1204][15:0];
endmodule
