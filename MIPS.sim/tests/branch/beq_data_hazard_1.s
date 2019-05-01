addi $t0, $t0, 5
# bubble
beq $t0, $t1, 4
# bubble
addi $t1, $t2, 4
sub $t4, $t3, $t2
add $t5, $t2, $t3
sw $t6, 2($t2)
lw $t7, 8($t2)
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero
add $t1, $t1, $zero

