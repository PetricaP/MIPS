# Should go to lw
addi $t1, $t1, 2
beq $t1, $t0, 4
# This instruction should not be executed
addi $t1, $t2, 3
sub $t4, $t3, $t2
add $t5, $t2, $t3
sw $t6, 2($t2)
# Should start execution from here
lw $t7, 8($t2)
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $zero, $zero, $zero

