module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY,
    module_running);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY, module_running;

    // add your code here

    wire [31:0] sum_result, cla_inputA;
    wire [31:0] M, i_M;
    wire [64:0] A_out, shifted_A;
    wire [31:0] cla_inputB;
    wire [64:0] A_data;
    wire [31:0] A_head;
    wire isSub;
    wire saveSum;
    wire Cout;
    wire A_write;
    wire cla_overflow_return;
    wire isDiv, isMult;
    wire M_is_zero;
    wire [5:0] count;
    wire [65:0] new_A;
    wire [31:0] input_A;
    wire operand_A_is_negative;

    wire shift_M;

    // Latch mult/div signal
    wire op_start = ctrl_MULT || ctrl_DIV;

    dffe_ref divLatch(.q(isDiv), .d(ctrl_DIV), .clk(clock), .en(op_start), .clr(count == 6'b100001));
    dffe_ref multLatch(.q(isMult), .d(ctrl_MULT), .clk(clock), .en(op_start), .clr(count == 6'b010001));

    dffe_ref dividend_sign_latch(.q(operand_A_is_negative), .d(data_operandA[31]), .clk(clock), .en(op_start));

    // Running
    tff toggle_running(.T(op_start || data_resultRDY), .clock(clock), 
        .en(op_start || data_resultRDY), .clr(1'b0), .q(module_running));

    // M
    reg32 M_reg(.data(data_operandB), .clk(clock), .write_enable(op_start), .out(M));

    assign i_M = isMult && shift_M ? M << 1 : M; // LSL 1 mult only if multplication

    // Negate operand A if negative for division
    negate_32 negate_dividend(.do_negate(data_operandA[31]), .operand(data_operandA), .result(input_A));

    // A Reg
    assign A_data = op_start ? (ctrl_MULT ? {{30{1'b0}}, data_operandA, 3'b000} : {{32{1'b0}}, input_A, 1'b0}) : new_A;
        // If operation starting
            // If mult: thirty 0's with operand A with 3 0's
            // If Div: thirty three 0's with operand A
        // else: A head with shifted A
        
    assign shifted_A = isMult ? {{2{A_out[64]}}, A_out[64:2]} : A_out << 1; // ASR 2 if Mult, LSL 1 if Div
    reg65 A_reg(.data(A_data), .write_enable(A_write), .clk(clock), .out(A_out));

    // Negated result if divisor and divdend had mismatching signs
    wire [31:0] div_result;
    negate_32 result_negate(.do_negate(^{M[31], operand_A_is_negative}), .operand(A_out[32:1]), .result(div_result));
    assign data_result = isMult ? shifted_A[32:1] : div_result;

    // assign data_result = shifted_A[32:1];

    // Subtract Mux logic

    assign cla_inputB = isSub ? ~i_M : i_M;


    // CLA unit (add, or, and)

    assign cla_inputA = shifted_A[64:33];

    cla32bit CLA32(
    .Cout(Cout), .sum(sum_result), .a(cla_inputA), .b(cla_inputB), .Cin(isSub));

    assign cla_overflow_return = (~(cla_inputA[31] ^ cla_inputB[31]) && (sum_result[31] ^ cla_inputA[31])) && saveSum; // Addition overflowed

    // A output logic
    wire [64:0] shifted_A_qbit = {shifted_A[64:2], (isMult ? shifted_A[1] : ~sum_result[31]), shifted_A[0]};
        // if Not Mult:
            // 2nd lsb of shifted_A is MSB of sum_result

    assign new_A = saveSum ? {sum_result, shifted_A_qbit[32:0]} : shifted_A_qbit;
        // If save sum:
            // sum_result + shiftedA[32:0]

    // Control logic
    wire [2:0] A_lsb = shifted_A[2:0];

    assign isSub = isMult ? A_lsb[2] : ~M[31]; // Do subtraction if 3rd lsb of A is 1 or (dividing and M is negative)
    assign saveSum = &{|A_lsb, ~&A_lsb, isMult} || &{~sum_result[31], isDiv}; // Save Sum result depending on mult condition or div condition
    assign A_write = ~data_resultRDY;
    assign shift_M = ~^A_lsb[1:0]; // Only impactful if isMult is asserted

    // Counter
    
    counter_mod32 counter(.clock(clock), .reset(op_start), .q(count), .enable(1'b1));

    assign data_resultRDY = ~op_start && ((isMult && (&{~count[5], count[4], ~|{count[3:0]}})) || cla_overflow_return || 
            (isDiv && ((&{count[5], ~|{count[4:0]}}) || ((&{~|{count[5:2]}, &{count[1:0]}}) && M_is_zero))));

    assign M_is_zero = ~|M;
    // Overflow
    wire bad_sign = ^{M[31], shifted_A[0], data_result[31]} && (|data_operandA && |data_operandB);
    assign data_exception =  (isMult && ((|shifted_A[64:32] && ~&shifted_A[64:32]) || bad_sign || cla_overflow_return)) || (isDiv && M_is_zero);

endmodule