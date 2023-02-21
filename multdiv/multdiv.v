module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    wire [31:0] sum_result, cla_inputA;
    wire [31:0] multiplicand, i_multiplicand;
    wire [64:0] product_out, shifted_product;
    wire [31:0] cla_inputB;
    wire [64:0] product_data;
    wire [31:0] product_head;
    wire isSub;
    wire doAdd;
    wire Cout;
    wire product_write;
    wire cla_overflow_return;
    wire isDiv, isMult;
    wire [4:0] count;

    wire shift_multiplicand;

    // Latch mult/div signal
    wire op_start = ctrl_MULT || ctrl_DIV;

    dffe_ref divLatch(.q(isDiv), .d(ctrl_DIV), .clk(clock), .en(op_start));
    dffe_ref multLatch(.q(isMult), .d(ctrl_MULT), .clk(clock), .en(op_start));

    // Multiplicand
    reg32 M_reg(.data(data_operandA), .clk(clock), .write_enable(op_start), .out(multiplicand));

    assign i_multiplicand = shift_multiplicand ? multiplicand << 1 : multiplicand;


    // Product Reg
    assign product_data = ctrl_MULT ? {{30{1'b0}}, data_operandB, 3'b000} : {product_head, shifted_product[32:0]};
    assign shifted_product = {{2{product_out[64]}}, product_out[64:2]};
    reg65 product(.data(product_data), .write_enable(product_write), .clk(clock), .out(product_out));

    assign data_result = shifted_product[32:1];

    // Subtract Mux logic
 
    assign cla_inputB = isSub ? ~i_multiplicand : i_multiplicand;


    // CLA unit (add, or, and)

    assign cla_inputA = shifted_product[64:33];

    cla32bit CLA32(
    .Cout(Cout), .sum(sum_result), .a(cla_inputA), .b(cla_inputB), .Cin(isSub));

    // xnor(operand_sign_match, data_operandA[31], cla_inputB[31]);
    // xor(result_sign_differs, sum_result[31], data_operandA[31]);

    // and(overflow, operand_sign_match, result_sign_differs);

    assign cla_overflow_return = (~(cla_inputA[31] ^ cla_inputB[31]) && (sum_result[31] ^ cla_inputA[31])) && doAdd;

    // Product output logic

    assign product_head = doAdd ? sum_result : shifted_product[64:33];

    // Control logic
    wire [2:0] product_lsb = shifted_product[2:0];

    assign isSub = product_lsb[2];
    assign doAdd = &{|product_lsb, ~&product_lsb};
    assign product_write = ~data_resultRDY;
    assign shift_multiplicand = ~^product_lsb[1:0];

    // Counter
    
    counter_mod32 counter(.clock(clock), .reset(ctrl_MULT), .q(count));

    assign data_resultRDY = ~ctrl_MULT && (count[4] || cla_overflow_return);

    // Overflow
    wire bad_sign = ^{multiplicand[31], shifted_product[0], data_result[31]} && (|data_operandA && |data_operandB);
    assign data_exception = (|shifted_product[64:32] && ~&shifted_product[64:32]) || bad_sign || cla_overflow_return;

endmodule