addi a0, zero, 10
ori a1, zero, 35
add a2, a0, a1
sub a2, a0, a1
and a2, a0, a1
or a2, a0, a1
lui a0, 100
addi a0, a0, 21
ori a1, zero, 36
add a2, a1, a0
andi a2, a2, 0xff
jal s11, test_func   # jump to the test func
sw a0, 100(a1)
lw s1, 100(a1)
ori a1, zero, 1     # a1 = 1, used for comparison in BEQ
ori a7, zero, 10    # number of iterations
ori a4, zero, 3     # the factor
sub a6, zero, zero  # loop counter
sub a5, zero, zero  # a5 is the result

loop: 
   add a5, a5, a4
   addi a6, a6, 1
   slt a3, a6, a7
   beq a3,a1, loop
   
   j end

test_func:
    addi s10, zero, 100
    jalr s9, s11, 0

end:
    nop
    nop

