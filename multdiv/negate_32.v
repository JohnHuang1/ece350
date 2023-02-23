module negate_32 (
    input do_negate,
    input [31:0] operand,
    output [31:0] result, 
    output overflow
);
    wire [31:0] inputA = do_negate ? ~operand : operand;
    cla32bit adder(.sum(result), .a(inputA), .b({{31{1'b0}}, do_negate}), .Cin(1'b0));
    assign overflow = do_negate && ~^{operand[31], result[31]} && |operand;
    // overflow if operand not zero
    // and if negating 
    // and if operand and result have same MSB (same signs)
    
endmodule