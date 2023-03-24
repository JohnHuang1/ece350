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
    wire[31:0] pc_data; // PC corresponding data signal
    wire pc_branch_wren; // PC write enable
    wire pc_reg_wren;
    // assign pc_reg_wren = 1'b1;
	reg32 pc_reg(.data(pc_in), .out(pc_out), .write_enable(pc_reg_wren), .clk(clock), .clear(reset));

    cla32bit pc_incrementer(.sum(pc_inc_out), .a(pc_out), .b({32{1'b0}}), .Cin(1'b1)); // add 1 to pc out

    assign pc_in = pc_branch_wren ? pc_data : pc_inc_out; // Write to pc reg depending on pc_branch_wren

    // Get Instruction
    assign address_imem = pc_out;

    // F/D regs
    wire[31:0] fd_pc_out, fd_ir_in, fd_ir_out;
    wire fd_wren;
    assign fd_ir_in = pc_branch_wren ? {32'd0} : q_imem; // If branch occurs, nop flushed in
    reg32 fd_pc_reg(.data(pc_inc_out), .out(fd_pc_out), .write_enable(fd_wren), .clk(clock), .clear(reset));
    reg32 fd_ir_reg(.data(fd_ir_in), .out(fd_ir_out), .write_enable(fd_wren), .clk(clock), .clear(reset));

    // Decode
    wire [31:0] ddo; //decoded decode stage opcode
    decoder32 d_opcode_decoder(.select(fd_ir_out[31:27]), .out(ddo), .enable(1'b1));
    assign ctrl_readRegA = fd_ir_out[21:17]; // Gets $rs from R/I-type inst.
    assign ctrl_readRegB = |{ddo[7], ddo[2], ddo[4], ddo[6]} ? fd_ir_out[26:22] : (ddo[22] ? 5'b11110 : fd_ir_out[16:12]); 
        // Gets $rt from R-type inst. (default)
        // Gets $rd from I/JII-type inst.
            // sw (00111)
            // bne (00010)
            // jr (00100)
            // blt (00110)
        // Gets $r30 (rstatus) if bex (10110)

    // D/X regs
    wire[31:0] dx_pc_out, dx_ir_in, dx_ir_out, dx_a_out, dx_b_out;
    wire dx_add_nop;
    assign dx_ir_in = dx_add_nop ? {32'd0} : fd_ir_out; // If branch occurs, nop flushed in
    reg32 dx_pc_reg(.data(fd_pc_out), .out(dx_pc_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_ir_reg(.data(dx_ir_in), .out(dx_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_a_reg(.data(data_readRegA), .out(dx_a_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 dx_b_reg(.data(data_readRegB), .out(dx_b_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Execute
    wire [31:0] alu_opA, alu_opB, alu_out, alu_result, alu_ex_code;
    wire[31:0] xm_ir_in;
    wire [4:0] alu_opcode, alu_shamt;
    wire [31:0] bypassed_a, bypassed_b; // Bypassed values 
    wire [31:0] dxo; //decoded execute stage opcode
    wire [4:0] updated_rd;
    decoder32 x_opcode_decoder(.select(dx_ir_out[31:27]), .out(dxo), .enable(1'b1));
    wire alu_neq, alu_lt, alu_of;
    alu math_unit(.data_operandA(alu_opA), .data_operandB(alu_opB), .data_result(alu_out), .ctrl_ALUopcode(alu_opcode), .ctrl_shiftamt(alu_shamt), .isNotEqual(alu_neq), .isLessThan(alu_lt), .overflow(alu_of));

    wire [31:0] sx_immediate = {{15{dx_ir_out[16]}}, dx_ir_out[16:0]};
    assign alu_opA = bypassed_a;
    assign alu_opB = |{dxo[5], dxo[7], dxo[8]} ? sx_immediate : bypassed_b;
    assign alu_opcode = dxo[0] ? dx_ir_out[6:2] : (dxo[2] || dxo[6] ? 5'b00001 : 5'b00000);
        // if (x stage op == alu_op (00000))
            // use alu_op
        // else if (x stage op == bne (00010) or blt (00110))
            // do sub (5'b00001)
        // else 
            // do add (5'b00000)
    assign alu_shamt = dx_ir_out[11:7];

    wire [31:0] dxao; //decoded execute stage alu opcode
    decoder32 x_alu_opcode_decoder(.select(alu_opcode), .out(dxao), .enable(1'b1));

    // On overflow
    wire is_of_opcode = dxao[0] || dxao[1] || dxo[5];
        // The following alu_opcodes can overflow
            // add (00000)
            // sub (00001)
            // addi (which is just add)
    assign alu_result = is_of_opcode && alu_of ? alu_ex_code : alu_out;

    assign updated_rd = (is_of_opcode && alu_of) || dxo[21] ? 5'b11110 : (dxo[3] ? 5'b11111 : dx_ir_out[26:22]);
    // sets xm_ir_in[26:22] = val
    // if (is_of_opcode && alu_of) || dx_ir_op == setx (10101)
        // val = $r30 ($rstatus)
    // else if dx_ir_op == jal (00011)
        // val = $r31 ($ra)
    // else
        // val = dx_ir_out[26:22] (default)


    // Assigning overflow values
    assign alu_ex_code = dxo[5] ? 32'd2 : 
            (dxo[0] ? 
                (dxao[0] ? 32'd1 : 
                (dxao[1] ? 32'd3 : 32'd0))
            : 32'd0);


    // Branch logic
    wire[31:0] on_branch_pc, pc_adder_out;

    cla32bit pc_adder(.a(dx_pc_out), .b(sx_immediate), .sum(pc_adder_out), .Cin(1'b0));
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
    assign on_branch_pc = opcode_is_branch_rd ? bypassed_b : {32{1'bz}};
        // branch for jr (001000)
            // branch pc = regfile b value
            // if not, line set to high impedance (z's)

    wire bne_condition = dxo[2] && alu_neq; // True if x op == bne (00010) && $rs != $rd
    wire blt_condition = dxo[6] && (alu_neq && ~alu_lt); // True if x op == blt (00110) && ($rs != $rd) && !($rs < $rd)
    wire bex_condition = dxo[22] && (bypassed_b != 5'd0); // if bex opcode (10110) then dx_b_out will have $rstatus. True if $rstatus != 0

    wire pc_direct_assign = dxo[1] || dxo[3] || dxo[4]; // opcodes that directly assign pc (j, jal, jr)
    assign pc_branch_wren = pc_direct_assign || bne_condition || blt_condition || bex_condition;
    assign pc_data = on_branch_pc;

    // X/M regs
    wire[31:0] xm_ir_out, xm_o_in, xm_o_out, xm_b_out;
    assign xm_ir_in = {dx_ir_out[31:27], updated_rd, dx_ir_out[21:0]};
    assign xm_o_in = dxo[3] ? dx_pc_out : (dxo[21] ? target : alu_result); 
        // Muxing xm_o_in
        // if jal (00011) 
            // val = pc + 1
        // else if setx (10101)
            // val = target
        // else
            // val = alu_result
    reg32 xm_ir_reg(.data(xm_ir_in), .out(xm_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 xm_o_reg(.data(xm_o_in), .out(xm_o_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 xm_b_reg(.data(bypassed_b), .out(xm_b_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Memory
    wire[31:0] bypassed_dm;
    assign address_dmem = xm_o_out;
    assign data = bypassed_dm;
    wire [31:0] dmo; //decoded memory stage opcode
    decoder32 m_opcode_decoder(.select(xm_ir_out[31:27]), .out(dmo), .enable(1'b1));
    assign wren = dmo[7]; // Data Memory write enable when opcode sw (00111)

    // M/W regs
    wire[31:0] mw_ir_in, mw_ir_out, mw_o_in, mw_o_out, mw_d_out;
    assign mw_ir_in = p_data_rdy ? p_ir_final : xm_ir_out;
    assign mw_o_in = p_data_rdy ? p_data : xm_o_out;
    reg32 mw_ir_reg(.data(mw_ir_in), .out(mw_ir_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 mw_o_reg(.data(mw_o_in), .out(mw_o_out), .write_enable(1'b1), .clk(clock), .clear(reset));
    reg32 mw_d_reg(.data(q_dmem), .out(mw_d_out), .write_enable(1'b1), .clk(clock), .clear(reset));

    // Write
    wire[31:0] dwo;
    decoder32 w_opcode_decoder(.select(mw_ir_out[31:27]), .out(dwo), .enable(1'b1));
    assign ctrl_writeReg = mw_ir_out[26:22];
        // write reg = mw_ir_out[26:22] for all cases
    assign data_writeReg = dwo[8] ? mw_d_out : mw_o_out;
        // if lw (01000) then 
            // write data from memory to reg
        // else 
            // write alu output to reg 
    assign ctrl_writeEnable = dwo[0] || dwo[5] || dwo [8] || dwo[3] || dwo[21];
        // enable regfile write if opcode:
            // alu_op 00000
            // addi 00101
            // jal 00011
            // setx 10101
            // lw 01000

    // Multdiv
    wire[31:0] multdiv_op_a, multdiv_op_b, multdiv_result;
    wire ctrl_MULT, ctrl_DIV, clock, multdiv_ex, multdiv_resultRDY, multdiv_active;
    multdiv mult_div_module(.data_operandA(multdiv_op_a), .data_operandB(multdiv_op_b), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), .clock(clock), .data_result(multdiv_result), .data_exception(multdiv_ex), .data_resultRDY(multdiv_resultRDY), .module_running(multdiv_active));

    wire [31:0] p_data, p_ir_out, p_ir_final;
    wire pw_p_ex_out, pw_p_rdy_out;
    // reg32 pw_p_reg(.data(multdiv_result), .out(pw_p_out), .write_enable(multdiv_resultRDY), .clk(clock), .clear(reset));
    reg32 p_ir_reg(.data(dx_ir_out), .out(p_ir_out), .write_enable(ctrl_MULT || ctrl_DIV || ~multdiv_active), .clk(clock), .clear(reset));
    // dffe_ref pw_p_ex_reg(.q(pw_p_ex_out), .d(multdiv_ex), .clk(clock), .en(multdiv_resultRDY), .clr(reset));
    // dffe_ref pw_p_rdy_reg(.q(pw_p_rdy_out), .d(multdiv_resultRDY), .clk(clock), .en(1'b1), .clr(reset));

    assign multdiv_op_a = bypassed_a;
    assign multdiv_op_b = bypassed_b;
    assign ctrl_MULT = dxo[0] && dxao[6];
    assign ctrl_DIV = dxo[0] && dxao[7];

    // dffe_ref p_latch(.q(multdiv_active), .d(ctrl_MULT || ctrl_DIV), .clk(clock), .en(ctrl_MULT || ctrl_DIV), .clr(multdiv_resultRDY || reset));

    wire[4:0] p_reg = multdiv_ex ? 5'b11110 : p_ir_out[26:22];
    assign p_ir_final = {p_ir_out[31:27], p_reg, p_ir_out[21:0]};
    assign p_data = multdiv_ex ? (p_ir_out[6:2] == 5'b00111 ? 32'd5 : 32'd4) : multdiv_result;

    wire p_data_rdy = multdiv_resultRDY && p_ir_out[31:27] == 5'd0 && (p_ir_out[6:2] == 5'b00110 || p_ir_out[6:2] == 5'b00111);

    // Bypass logic
    wire bp_xm_a, bp_mw_a, bp_xm_b, bp_mw_b, bp_mw_dm; // "bypass_(stage reg)_a/b/dm"
        // whether values should be by passed from the specified stage to the specified variable
            // a = execute stage val a
            // b = execute stage val b
            // dm = memory stage val data
        // xm has priority over mw because more recent

    assign bypassed_dm = bp_mw_dm ? data_writeReg : xm_b_out;
    assign bypassed_a = bp_xm_a ? xm_o_out : (bp_mw_a ? data_writeReg : dx_a_out);
    assign bypassed_b = bp_xm_b ? xm_o_out : (bp_mw_b ? data_writeReg : dx_b_out);
        // if bypass from xm
            // xm o reg val is used
        // else if bypass from mw
            // data_writeReg line is used
        // else
            // dx_a/b_out value is used (normal value)

    wire xm_op_is_write_to_reg = dmo[0] || dmo[5] || dmo[8] || dmo[3] || dmo[21];
        // if opcode is one of following then it writes to reg defined by xm_ir[26:22]
            // alu_op (00000)
            // addi (00101)
            // lw (01000)
            // jal (00011)
            // setx (10101) 
                // Both jal and setx are JI-type instr but their dest reg is set in xm_ir[26:22]

    wire dx_op_reads_rs = dxo[0] || dxo[2] || dxo[5] || dxo[6] || dxo[7] || dxo[8];
        // if opcode is one of following then it reads from $rs (ir[21:17])
            // alu_op (00000)
            // bne (00010)
            // addi (00101)
            // blt (00110)
            // sw (00111)
            // lw (01000)
    wire [4:0] dx_ir_rs = dx_ir_out[21:17];
    wire [4:0] dx_ir_rd = dx_ir_out[26:22];
    wire [4:0] xm_ir_rd = xm_ir_out[26:22];

    // Check that these regs aren't zero
    wire w_reg_dest_nz = ctrl_writeReg != 5'd0;
    wire xm_ir_rd_nz = xm_ir_rd != 5'd0;

    // Bypass logic for val a (bypass into execute stage)
    assign bp_xm_a = dx_op_reads_rs && xm_op_is_write_to_reg && (xm_ir_rd == dx_ir_rs) && xm_ir_rd_nz;
        // True if (x op reads rs) && (m op write rd) && (x stage rs reg == m stage rd reg) && (xm_ir_rd != $r0)

    assign bp_mw_a = dx_op_reads_rs && ctrl_writeEnable && (ctrl_writeReg == dx_ir_rs) && w_reg_dest_nz;
        // True if dx_op_reads_rs && (w stage is writing) && (w stage reg == x stage rs reg) && (w stage reg != $r0)

    // Bypass logic for val b (bypass into execute stage)
    wire dx_op_reads_rt = dxo[0];
        // if opcode is alu_op (00000) then $rt is read from ir[16:12]
    wire dx_op_reads_rd = dxo[2] || dxo[4] || dxo[6] || dxo[7];
        // Following opcodes read from $rd ir[26:22]
            // bne (00010)
            // jr (00100)
            // blt (00110)
            // sw (00111)

    wire [4:0] dx_b_read_reg = dx_op_reads_rt ? dx_ir_out[16:12] : (dx_op_reads_rd ? dx_ir_rd : 5'bzzzzz);
        // assign dx_b_read_reg (which reg dx stage is reading from for val b)
        // if dx_op_reads_rt
            // = dx_ir_rt ir[16:12](for R type instr)
        // else if dx_op_reads_rd
            // = dx_ir_rd ir[26:22]
        // else
            // = zzzzz
    wire dx_reads_rt_rd = dx_op_reads_rd || dx_op_reads_rt;
    assign bp_xm_b = xm_op_is_write_to_reg && dx_reads_rt_rd && (xm_ir_rd == dx_b_read_reg) && xm_ir_rd_nz;
        // true if (m stage op writes to reg) && (x stage read from rt/rd) && (those regs match) && (xm_ir_rd != $r0)
    assign bp_mw_b = ctrl_writeEnable && dx_reads_rt_rd && (ctrl_writeReg == dx_b_read_reg) && w_reg_dest_nz;
        // true if (w stage is writing) && (x stage read from rt/rd) && (those regs match) && (w stage reg != $r0)

    // Bypass logic for Mem stage (from write stage to mem stage)
    assign bp_mw_dm = ctrl_writeEnable && wren && (ctrl_writeReg == xm_ir_rd) && w_reg_dest_nz;
        // true if (w stage is writing) && (memory is writing (op == sw)) && (w stage write reg == m stage rd reg)


    // Stall Logic for LW (Stall any instr that reads the lw rd reg)
    wire fd_op_reads_rd = dxo[2] || dxo[4] || dxo[6];
        // The following opcodes read from $rd fd_ir[26:22]
            // bne (00010)
            // jr (00100)
            // blt (00110)
            // sw (00111) (don't need this one because of w to m stage bypass)
    wire fd_op_reads_rs = dxo[0] || dxo[2] || dxo[5] || dxo[6] || dxo[7] || dxo[8];
        // if opcode is one of following then it reads from $rs (fd_ir[21:17])
            // alu_op (00000)
            // bne (00010)
            // addi (00101)
            // blt (00110)
            // sw (00111)
            // lw (01000)
    wire fd_op_reads_rt = dxo[0];
        // if opcode is alu_op (00000) then $rt is read from fd_ir[16:12]
    wire fd_op_reads_status = dxo[22];
        // if op == bex (10110) then will read $r30 ($rstatus)

    wire stall = dxo[8] && (
        (fd_op_reads_rd && (dx_ir_rd == fd_ir_out[26:22])) ||
        (fd_op_reads_rs && (dx_ir_rd == fd_ir_out[21:17])) ||
        (fd_op_reads_rt && (dx_ir_rd == fd_ir_out[16:12])) ||
        (fd_op_reads_status && (dx_ir_rd == 5'b11110))
    ) || multdiv_active;
        // stall if dx_ir_op == lw (01000) && 
            // (fd op reads reg_xx) && (reg_xx == dx_ir_rd) (this but all cases)
        // also stall if multdiv is active
    assign pc_reg_wren = ~stall;
    assign fd_wren = ~stall;
    assign dx_add_nop = stall || pc_branch_wren;

endmodule
