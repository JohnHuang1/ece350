# Memory addressed Addition
nop
nop
nop
loop:
lw $r1, 50($r0)
lw $r2, 51($r0)
add $r3, $r1, $r2
sw $r3, 54($r0)
j loop
nop
nop
nop
nop