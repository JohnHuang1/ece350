nop
nop
nop
nop
loop:
ldi $r1, $r0, 0 # store inputs into registers
ldi $r2, $r0, 1
ldi $r3, $r0, 2
ldi $r4, $r0, 3
ldi $r5, $r0, 4
ldi $r6, $r0, 5
ldi $r7, $r0, 6
ldi $r8, $r0, 7
sll $r8, $r8, 7 # shift inputs based on input number
sll $r7, $r7, 6
sll $r6, $r6, 5
sll $r5, $r5, 4
sll $r4, $r4, 3
sll $r3, $r3, 2
sll $r2, $r2, 1
or $r8, $r8, $r7 # or inputs together
or $r8, $r8, $r6
or $r8, $r8, $r5
or $r8, $r8, $r4
or $r8, $r8, $r3
or $r8, $r8, $r2
or $r8, $r8, $r1
sw $r8, 1000($r0) # write inputs to pwm reg 0
j loop #repeat
nop
