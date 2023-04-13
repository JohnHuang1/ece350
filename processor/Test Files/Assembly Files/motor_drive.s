# Motor clk 4 (fpga 0)
# Motor enable 7 (fpga 1)
# Motor data 8 (fpga 2)
# Motor latch 12 (fpga 3)
nop
nop
nop
nop
j main
nop
addi $r2, $r0, 0
latch_tx: # initiall run has latch state $r2 = 0
addi $r1, $r0, 128 # 1 to be logically left shifted
writel $r0, $r0, 3 # latch low
writel $r0, $r0, 2 # data low
# latch state assumed to be in $r2
latch_loop:
writel $r0, $r0, 0
and $r3, $r2, $r1 # and conditional in r3
bne $r3, $r0, data_high # if r3 == 0 bit in latch state is not high
writel $r0, $r0, 2 # data low
j end_write_data
data_high:
writeh $r0, $r0, 2 # data high
end_write_data:
nop
nop
writeh $r0, $r0, 0 # clock high
sra $r1, $r1, 1 # shift mask (r1) right by 1
bne $r1, $r0, latch_loop # loop until r1 == 0
writeh $r0, $r0, 3 # latch high
jr $ra #return to latch _tx call
nop
main:
jal latch_tx
addi $r1, $r0, 4
or $r2, $r2, $r1
jal latch_tx
nop
nop
loop:
nop
j loop
nop