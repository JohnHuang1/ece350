module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    // add 00000
    // sub 00001
    // and 00010
    // or  00011
    // sll 00100
    // sra 00101

    // Result Mux
    wire [31:0] sum_result, and_result, or_result, sll_result, sra_result; 

    mux_32 mux_result(.out(data_result), .select(ctrl_ALUopcode), 
        .in0(sum_result), .in1(sum_result), .in2(and_result), .in3(or_result), 
        .in4(sll_result), .in5(sra_result));

    // Subtract Mux logic

    wire [31:0] not_operandB, cla_inputB;

    not_32 notB(.out(not_operandB), .in(data_operandB));

    wire isZeros, isSub;

    nor (isZeros, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1]); // Check first 4 bits of opcode is zero
    and (isSub, isZeros, ctrl_ALUopcode[0]); // isSub = 1 if opcode == 00001, otherwise 0
    
    mux_2 selectB(.out(cla_inputB), .select(isSub), .in0(data_operandB), .in1(not_operandB));


    // CLA unit (add, or, and)
    wire Cout;
    cla32bit CLA32(
    .Cout(Cout), .sum(sum_result), .and_32(and_result), .or_32(or_result), .a(data_operandA), .b(cla_inputB), .Cin(isSub));

    // Overflow
    wire operand_sign_match, result_sign_differs;

    xnor(operand_sign_match, data_operandA[31], cla_inputB[31]);
    xor(result_sign_differs, sum_result[31], data_operandA[31]);

    and(overflow, operand_sign_match, result_sign_differs);


    // isNotEqual (assume subtract operation is done & not overflow)
    
    wire [3:0] notEqualInterim;

    or (notEqualInterim[0], sum_result[0], sum_result[1], sum_result[2], sum_result[3], sum_result[4], sum_result[5], sum_result[6], sum_result[7]);
    or (notEqualInterim[1], sum_result[8], sum_result[9], sum_result[10], sum_result[11], sum_result[12], sum_result[13], sum_result[14], sum_result[15]);
    or (notEqualInterim[2], sum_result[16], sum_result[17], sum_result[18], sum_result[19], sum_result[20], sum_result[21], sum_result[22], sum_result[23]);
    or (notEqualInterim[3], sum_result[24], sum_result[25], sum_result[26], sum_result[27], sum_result[28], sum_result[29], sum_result[30], sum_result[31]);

    or (isNotEqual, notEqualInterim[0], notEqualInterim[1], notEqualInterim[2], notEqualInterim[3]);

    // isLessThan (assume subtract operation is done & not overflow (aka sum_result is correct))
    // isLessThan = a < b
    xor (isLessThan, overflow, sum_result[31]);
    
    // SLL (assume ctrl_shiftamt is unsigned integer)

    left_shift_32_barrel leftShiftLogical(.in(data_operandA), .shiftAmt(ctrl_shiftamt), .copyBit(1'b0), .out(sll_result));

    // SRA (invert A, leftshift arithmetic, invert shift result)
    wire [31:0] A_inverse, shifted_A_inverse;

        // Reverse bits of A
    generate for(genvar i = 0; i < 32; i = i + 1) 
        assign A_inverse[i] = data_operandA[31-i];
    endgenerate

        // Left shift reversed bits by the LSB of the reverse
    left_shift_32_barrel rightShiftArithmetic(.in(A_inverse), .shiftAmt(ctrl_shiftamt), .copyBit(A_inverse[0]), .out(shifted_A_inverse));

        // Reverse shift result to get sra of A
    generate for(genvar i = 0; i < 32; i = i + 1) 
        assign sra_result[i] = shifted_A_inverse[31-i];
    endgenerate

endmodule