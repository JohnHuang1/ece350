module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	num1, num2,
	out1
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	// Direct I/O input
	input [31:0] num1, num2;

	// Direct I/O output
	output [31:0] out1;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here

	// Decode select signals
	wire [31:0] write_rd, readA_reg, readB_reg;
	decoder32 decoderW(.select(ctrl_writeReg), .enable(ctrl_writeEnable), .out(write_rd));
	decoder32 decoderA(.select(ctrl_readRegA), .enable(1'b1), .out(readA_reg));
	decoder32 decoderB(.select(ctrl_readRegB), .enable(1'b1), .out(readB_reg));

	// Generate registers
	genvar i;
	generate
		for(i = 2; i < 30; i = i + 1) begin: reg_loop
			wire [31:0] reg_out;
			reg32 register(.data(data_writeReg),
				.write_enable(write_rd[i]), .clk(clock), .clear(ctrl_reset),
				.out(reg_out));
			
			assign data_readRegA = readA_reg[i] ? reg_out : 32'bz;
			assign data_readRegB = readB_reg[i] ? reg_out : 32'bz;
			
		end
	endgenerate

	// Register 0
	assign data_readRegA = readA_reg[0] ? 32'b0 : 32'bz;
	assign data_readRegB = readB_reg[0] ? 32'b0 : 32'bz;

	// Register 1

	wire [31:0] reg1_out;
	reg32 register1(.data(data_writeReg),
		.write_enable(write_rd[1]), .clk(clock), .clear(ctrl_reset),
		.out(reg1_out));
	
	assign data_readRegA = readA_reg[1] ? reg1_out : 32'bz;
	assign data_readRegB = readB_reg[1] ? reg1_out : 32'bz;

	assign out1 = reg1_out;

	// Register 31
	assign data_readRegA = readA_reg[31] ? num2 : 32'bz;
	assign data_readRegB = readB_reg[31] ? num2 : 32'bz;

	// Register 30
	assign data_readRegA = readA_reg[30] ? num1 : 32'bz;
	assign data_readRegB = readB_reg[30] ? num1 : 32'bz;


endmodule
