nop
nop
nop
nop
sw $r0, 1000($r0)
addi $r1, $r0, 192
addi $r2, $r0, 128
addi $r3, $r0, 64
sw $r1, 1001($r0)
sw $r2, 1002($r0)
sw $r3, 1003($r0)
nop
nop
nop
loop:
nop
j loop
nop
nop