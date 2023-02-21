# REGFILE
## Name: John Huang

## Description of Design

A decoder using the verilog left logical shift (<<) was used to decode the ctrl write and read register signals. 

A generate loop was used to create 31 32-bit registers and their corresponding ternary operators which were used to choose which register to read from based on the decoded control signals.

Register 0 was wired using the ternary operator such that when the register chosen to be read from was the 0'th register, the output of the register file would always be 32 zeros.

Each 32-bit register contains 32 D-flip-flops which were generated using a generate loop utilizing the **dffe_ref** module given to us as the basic bit storage module.

## Bugs

No known bugs at the time of writing.
