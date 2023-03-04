# MULT
## Name: John Huang

## Description of Design

data_operandB stored in 32-bit register M whose output is shifted and/or inverted based on the control signals shift_M and isSub. This value is inputed into a carry-lookahead adder *(CLA) as cla_inputB.

data_operandA is written into the 65-bit register A. When ctrl_MULT is asserted, the A register is initialized as 30 zeros, followed by data_operandB, followed by 3 more zeros. This is because an implicit first shift of the values in product is done when the calculations begin. When ctrl_DIV is asserted, the value is left padded with 32 zeros and right padded with 1 zero. The LSB of reg A is not used for division.

The output of the A register is arithmetically shifted to the right by 2 if the operation is multiplication, and is logically left shifted by 1 if the operation is division.

The other input of the CLA is cla_inputA which is the first 32 MSB of the shifted_A.

The output of the CLA is written to the MSB of the A register if doAdd is asserted.

A mod-64 counter module made using T-flip flops is used to count to the decimal value 16 for multiplication or 32 for division, after which the data_resultRDY signal is asserted.

A_write is a control signal that enables the A register to write new values, this is assigned as the inverse of data_resultRDY.

The control signals are derived from the 3 LSB of shifted_A using various combinations of reduction operators and in-line gates.

## Bugs

No known bugs at the time of writing.