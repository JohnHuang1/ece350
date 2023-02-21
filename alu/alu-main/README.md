# ALU
## Name: John Huang

## Description of Design

A 32-input mux was used to select the correct result depending on the 5-bit opcode. A 32-input mux was used to future proof incase future opcoodes are used.

Subtraction logic was implemented by getting the inverse of operand B and inputting that into the carry-lookahead adder (CLA) based on a 2-input mux if subtraction was the operation selected. A carry in of 1 was also inputted if the the opcode selected was subtraction.

AND and OR operations were taken from the first-level propgate and generate functions of the CLA.

Overflow was implemented by xnor'ing the MSB of either operand (post inverse if needed), xor'ing the MSB of operand A with the MSB of the result of the operation, and AND'ing those two results. The logic implemented was if the sign of the operands is equal and the resulting sign is not equal to those signs then an overflow occured.

NotEqual was implemented by using 4 8-input or gates and another 4-input or gate to OR all of the bits of the result after subtraction to essentially check if the result is 0.

LessThan was implemented by XOR'ing the overflow with the MSB of the sum result.

SLL was implemented using a 32-bit left barrel shifter.

SRA was implemented using the same barrel shifter as SLL except operand A was reversed before and after being arithmetically shifted left to simulate a right arithmetic shift.

## Bugs

No known bugs at the time of writing.
