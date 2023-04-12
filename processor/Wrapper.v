`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 iverilog -o proc -c CFILES.txt -s Wrapper_tb -P Wrapper_tb.FILE=\"sample\"
 **/

module Wrapper (input CLK10MHZ, input CPU_RESETN, input [7:0] SW,
		output [5:1] JA, output [8:1] JB
    );

	wire reset = ~CPU_RESETN;
    wire clock = CLK10MHZ;
	wire [31:0] pwmReg0, pwmReg1, pwmReg2, pwmReg3;
	
	// assign JA[5] = clock;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
		
    ila_0 debugger(.clk(CLK10MHZ), 
		.probe0(pwmReg0),
		.probe1(pwmReg1),
		.probe2(rData),
		.probe3(regA),
		.probe4(regB),
		.probe5(rd),
		.probe6(rs1),
		.probe7(JA[4:1]),
		.probe8(mwe),
		.probe9(reset),
		.probe10(rwe),
		.probe11(pwmReg2),
		.probe12(pwmReg3));

	// PWM Out
	pwm_generator #(.SLOW_CLOCK_BITS(13))pwm0_gen(.clk(clock), .en(1'b1), .duty_cycle(SW), .pwm_out(JA[1]));
	pwm_generator #(.SLOW_CLOCK_BITS(12)) pwm1_gen(.clk(clock), .en(1'b1), .duty_cycle(SW), .pwm_out(JA[2]));
	pwm_generator #(.SLOW_CLOCK_BITS(11)) pwm2_gen(.clk(clock), .en(1'b1), .duty_cycle(SW), .pwm_out(JA[3]));
	pwm_generator #(.SLOW_CLOCK_BITS(10)) pwm3_gen(.clk(clock), .en(1'b1), .duty_cycle(SW), .pwm_out(JA[4]));
	pwm_generator #(.SLOW_CLOCK_BITS(9)) pwm4_gen(.clk(clock), .en(1'b1), .duty_cycle(SW), .pwm_out(JA[5]));



	// ADD YOUR MEMORY FILE HERE
	// localparam INSTR_FILE = "Test Files/Memory Files/rep_add";
	localparam FILE = "pwm_basic";
	localparam DIR = "C:/Users/johnj/dev/ece350/processor/Test Files/";
	localparam MEM_DIR = "Memory Files/";
	localparam OUT_DIR = "Output Files/";
	localparam VERIF_DIR = "Verification Files/";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		// Output Lines
		.output_pins(JB[8:1])
		); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({DIR, MEM_DIR, FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut), 
		
		// PWM Reg Output
		.pwm0(pwmReg0), .pwm1(pwmReg1), .pwm2(pwmReg2), .pwm3(pwmReg3));

endmodule
