nop
nop
nop
nop
loop:
writeh $r0, $r0, 0
addi $r1, $r0, 1
writeh $r0, $r1, 0
addi $r2, $r0, 2
writeh $r0, $r2, 0
addi $r3, $r0, 3
writeh $r0, $r3, 0
writel $r0, $r0, 0
writel $r0, $r0, 1
writel $r0, $r0, 2
writel $r0, $r0, 3
nop
nop
j loop
nop