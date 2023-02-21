# MULT
## Name: John Huang

## Description of Design

data_operandA was stored as the multiplicand in a 32-bit register whose output is shifted and/or inverted based on the control signals shift_multiplicand and isSub. This value is inputed into a carry-lookahead adder *(CLA) as cla_inputB.

data_operandB is written into the 65-bit product register. When ctrl_MULT is asserted, the product register is initialized as 30 zeros, followed by data_operandB, followed by 3 more zeros. This is because an implicit first shift of the values in product is done when the calculations begin.

The output of the product register is arithmetically shifted to the right by 2 constantly, and this shifted value is the one used for calculations, hence called shifted_product.

The other input of the CLA is cla_inputA which is the first 32 MSB of the shifted_product.

The output of the CLA is written to the MSB of the product register if doAdd is asserted.

A mod-32 counter module made using T-flip flops is used to count to the decimal value 16, after which the data_resultRDY signal is asserted.

product_write is a control signal that enables the product register to write new values, this is assigned as the inverse of data_resultRDY.

The control signals are derived from the 3 LSB of shifted_product using various combinations of reduction operators and in-line gates.

## Bugs

No known bugs at the time of writing.