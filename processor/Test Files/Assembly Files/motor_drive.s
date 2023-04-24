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
addi $r1, $r0, 128 # 128 to be arithmetically right
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
#addi $r1, $r0, 4 # set motor1_A (2) to drive
addi $r1, $r1, 32 # set motor3_A (5) to drive
addi $r1, $r1, 1 # set motor4_A (0) to drive
or $r2, $r2, $r1
jal latch_tx
addi $r21, $r0, 1 # Register with value 1 for comparison
addi $r22, $r0, 2 # Register with value 2 for comparison
addi $r8, $r0, 255 # Full power $r8 = 11111111
addi $r7, $r0, 106 # ~ 5V (?) power delivered
# No power $r0 = 00000000
addi $r9, $r0, 6 # ~ 0.5 ms Pulse width $r9 = 00000111 Full CW
addi $r10, $r0, 30 # ~ 2.5 ms Pulse width $r10 = 00100000 Full CCW
nop
# Input/Output checks
    # Motor addresses:
        # 1000 - right & left Fire Motor
        # 1001 - Feed Servo
        # 1002 - Tilt Servo
        # 1003 - Pan Servo
    # Inputs:
        # 0 = Fire
        # 1 = Right
        # 2 = Left
        # 3 = up
        # 4 = down
        # 12 = Right Limit
        # 13 = Left Limit
        # 14 = Up Limit
        # 15 = Down Limit
input:
ldi $r11, $r0, 8 # Input is Firing button
ldi $r12, $r0, 9 # Auto Button
add $r11, $r11, $r12
bne $r11, $r0, do_fire # if input true then jump to do_fire
sw $r0, 1000($r0)
sw $r0, 1001($r0)
j pan
do_fire:
addi $r12, $r12, 1 # $r12 will be 1 when auto isn't pressed but fire button is, and will be 2 when auto is pressed no matter what state fire button is in
sw $r8, 1000($r0)
sw $r12, 1001($r0)
pan:
ldi $r11, $r0, 5 # $r11 Move Right
ldi $r12, $r0, 7 # $r12 Move Left
ldi $r16, $r0, 12 # $r16 Right limit
ldi $r17, $r0, 13 # $r17 left limit
add $r15, $r11, $r12
blt $r15, $r22, do_pan # if $15 == 2, both right and left pressed, don't move.
j no_pan
do_pan:
bne $r11, $r21, check_left # branch if Move Right btn not pressed
bne $r16, $r0, check_left # branch if Right limit pressed
sw $r9, 1003($r0) # Turn Right, Pan servo full CW
j tilt
check_left:
bne $r12, $r21, no_pan # branch if Move Left btn not pressed
bne $r17, $r0, no_pan # branch if Left limit pressed
sw $r10, 1003($r0) # Turn Left, Pan Servo full CCW
j tilt
no_pan:
sw $r0, 1003($r0)
tilt:
ldi $r13, $r0, 6 # $r13 Move Up
ldi $r14, $r0, 4 # $r14 Move Down
ldi $r18, $r0, 14 # $r18 Up limit
ldi $r19, $r0, 15 # $r19 Down limit
add $r15, $r13, $r14
blt $r15, $r22, do_tilt # if $15 == 2, both up and down pressed, don't move.
j no_tilt
do_tilt:
bne $r13, $r21, check_down # branch if Move Up btn not pressed
bne $r18, $r0, check_down # branch if Up limit pressed
sw $r9, 1002($r0) # Tile Up, Tilt servo full CW
j movement_end
check_down:
bne $r14, $r21, no_tilt # branch if Move Down btn not pressed
bne $r19, $r0, no_tilt # branch if Down limit pressed
sw $r10, 1002($r0) # Tilt Down, Tilt Servo full CCW
j movement_end
no_tilt:
sw $r0, 1002($r0)
movement_end:
j input
nop
loop:
nop
j loop
nop