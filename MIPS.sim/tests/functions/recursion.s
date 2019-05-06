main:
	addi $a0, $zero, 5
	jal sum
.end main

sum:
	addi $sp, $sp, -8
	sw $ra, ($sp)

	beq $a0, $zero, return_zero

# recursive call
	sw $a0, 4($sp)
	addi $a0, $a0, -1

	jal sum

	lw $t0, 4($sp)
	add $v0, $v0, $t0
	j exit
return_zero:
	add $v0, $zero, $zero
exit:
	lw $ra, ($sp)
	addi $sp, $sp, 8
	jr $ra
.end sum

