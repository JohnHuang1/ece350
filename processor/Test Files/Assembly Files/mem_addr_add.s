# Memory addressed Addition
nop
nop
nop
loop:
lw $r1, 1200($r0)
lw $r2, 1201($r0)
add $r3, $r1, $r2
sw $r3, 1204($r0)
j loop
nop
nop
nop
nop