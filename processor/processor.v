/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // Falling edge clock
    wire n_clock = ~clock;
	
	// Program Counter

    wire [31:0] pc_in, pc_out, pc_inc_out;
    wire[31:0] pc_data, pc_wren; // PC write enable and corresponding data signal
    wire pc_write;
    assign pc_write = 1'b1;
	reg32 pc_reg(.data(pc_in), .out(pc_out), .write_enable(pc_write), .clk(clock), .clear(reset));

    cla32bit pc_incrementer(.sum(pc_inc_out), .a(pc_out), .b({32{1'b0}}), .Cin(1'b1)); // add 1 to pc out

    assign pc_in = pc_wren ? pc_data : pc_inc_out; // Write to pc reg depending on pc_wren

    // Get Instruction
    assign address_imem = pc_out;

    // F/D regs
    wire[31:0] fd_pc_out, fd_ir_in, fd_ir_out;
    assign fd_ir_in = pc_wren ? {32'd0} : q_imem; // If branch occurs, nop flushed in
    reg32 fd_pc_reg(.data(pc_inc_out), .out(fd_pc_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 fd_ir_reg(.data(fd_ir_in), .out(fd_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Decode
    wire [31:0] ddo; //decoded decode stage opcode
    decoder32 d_opcode_decoder(.select(fd_ir_out[31:27]), .out(ddo), .enable(1'b1));
    assign ctrl_readRegA = fd_ir_out[21:17]; // Gets $rs from R-type inst.
    assign ctrl_readRegB = |{ddo[7], ddo[2], ddo[4], ddo[6]} ? fd_ir_out[26:22] : (dxo[22] ? 5'b11110 : fd_ir_out[16:12]); 
        // Gets $rt from R-type inst.
        // Gets $rd from I/JII-type inst.
            // sw (00111)
            // bne (00010)
            // jr (00100)
            // blt (00110)
        // Gets $r30 (rstatus) if bex (10110)

    // D/X regs
    wire[31:0] dx_pc_out, dx_ir_in, dx_ir_out, dx_a_out, dx_b_out;
    assign dx_ir_in = pc_wren ? {32'd0} : fd_ir_out; // If branch occurs, nop flushed in
    reg32 dx_pc_reg(.data(fd_pc_out), .out(dx_pc_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_ir_reg(.data(dx_ir_in), .out(dx_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_a_reg(.data(data_readRegA), .out(dx_a_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_b_reg(.data(data_readRegB), .out(dx_b_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Execute
    wire [31:0] alu_opA, alu_opB, alu_out, alu_result, alu_ex_code;
    wire[31:0] xm_ir_in;
    wire [4:0] alu_opcode, alu_shamt;
    wire [31:0] dxo; //decoded execute stage opcode
    decoder32 x_opcode_decoder(.select(dx_ir_out[31:27]), .out(dxo), .enable(1'b1));
    wire alu_neq, alu_lt, alu_of;
    alu math_unit(.data_operandA(alu_opA), .data_operandB(alu_opB), .data_result(alu_out), .ctrl_ALUopcode(alu_opcode), .ctrl_shiftamt(alu_shamt), .isNotEqual(alu_neq), .isLessThan(alu_lt), .overflow(alu_of));

    wire [31:0] sx_immediate = {{15{dx_ir_out[16]}}, dx_ir_out[16:0]};
    assign alu_opA = dx_a_out;
    assign alu_opB = |{dxo[5], dxo[7], dxo[8]} ? sx_immediate : dx_b_out;
    assign alu_opcode = dxo[0] ? dx_ir_out[6:2] : 5'b00000;
    assign alu_shamt = dx_ir_out[11:7];

    // On overflow
    wire is_of_opcode = alu_opcode == 5'b00000 || alu_opcode == 5'b00001 || dxo[5];
    assign alu_result = is_of_opcode && alu_of ? alu_ex_code : alu_out;
    assign xm_ir_in = is_of_opcode && alu_of ? {dx_ir_out[31:27], 5'b11110, dx_ir_out[21:0]} : dx_ir_out; // if overflow then set $rd to $r30 (rstatus)

    // Assigning overflow values
    assign alu_ex_code = alu_opcode == 5'b00000 ? 32'd1 : {32{1'bz}};
    assign alu_ex_code = alu_opcode == 5'b00001 ? 32'd2 : {32{1'bz}};
    assign alu_ex_code = dxo[5] ? 32'd3 : {32{1'bz}};

    // Branch logic
    wire[31:0] on_branch_pc, pc_adder_out;

    cla32bit pc_adder(.a(dx_pc_out), .b(sx_immediate), .sum(pc_adder_out));
    wire opcode_is_branch_N = dxo[2] || dxo[6];
    assign on_branch_pc = opcode_is_branch_N ? pc_adder_out : {32{1'bz}};
        // Branch for bne (00010) and blt (00110)
            // If so, branch pc = PC + 1 + N
            // if not, line set to high impedance (z's)

    wire [31:0] target = {5'b00000, dx_ir_out[26:0]};
    wire opcode_is_branch_T = dxo[1] || dxo[3] || dxo[22];
    assign on_branch_pc = opcode_is_branch_T ? target : {32{1'bz}};
        // branch for j (00001), jal (00011), and bex (10110)
            // If so, branch pc = T
            // if not, line set to high impedance (z's)

    wire opcode_is_branch_rd = dxo[4];
    assign on_branch_pc = opcode_is_branch_rd ? dx_b_out : {32{1'bz}};
        // branch for jr (001000)
            // branch pc = regfile b value
            // if not, line set to high impedance (z's)

    wire bne_condition = dxo[2] || alu_neq; // True if $rs != $rd
    wire blt_condition = dxo[6] || (alu_neq && ~alu_lt); // True if ($rs != $rd) && !($rs < $rd)
    wire bex_condition = dxo[22] || ~|{dx_b_out}; // if bex opcode then dx_b_out will have $rstatus. True if $rstatus == 0

    wire pc_direct_assign = dxo[1] || dxo[3] || dxo[4]; // opcodes that directly assign pc (j, jal, jr)
    assign pc_wren = pc_direct_assign || bne_condition || blt_condition || bex_condition;
    assign pc_data = on_branch_pc;

    // X/M regs
    wire[31:0] xm_ir_out, xm_o_in, xm_o_out, xm_b_out;
    assign xm_o_in = dxo[3] ? dx_pc_out : alu_result; // x/m O reg = pc + 1 if jal (00011) else alu_result
    reg32 xm_ir_reg(.data(xm_ir_in), .out(xm_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 xm_o_reg(.data(xm_o_in), .out(xm_o_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 xm_b_reg(.data(dx_b_out), .out(xm_b_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    wire [31:0] dmo; //decoded memory stage opcode

    // Memory
    assign address_dmem = xm_o_out;
    assign data = xm_b_out;
    decoder32 m_opcode_decoder(.select(xm_ir_out[31:27]), .out(dmo), .enable(1'b1));
    assign wren = dmo[7]; // Data Memory write enable when opcode sw (00111)

    // M/W regs
    wire[31:0] mw_ir_out, mw_o_out, mw_d_out;
    reg32 mw_ir_reg(.data(xm_ir_out), .out(mw_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 mw_o_reg(.data(xm_o_out), .out(mw_o_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 mw_d_reg(.data(q_dmem), .out(mw_d_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Write
    wire[31:0] dwo;
    decoder32 w_opcode_decoder(.select(mw_ir_out[31:27]), .out(dwo), .enable(1'b1));
    assign ctrl_writeReg = mw_ir_out[26:22];
    assign data_writeReg = dwo[8] ? mw_d_out : mw_o_out;
    // if opcode == 01000 (lw) then 
        // write data from memory to reg
    // else 
        // write alu output to reg 
    assign ctrl_writeEnable = dwo[0] || dwo[5] || dwo[8] || dwo[25];
    // enable regfile write if opcode:
    //  00000, 00101, 10101, 00011

endmodule
