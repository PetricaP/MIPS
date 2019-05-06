main:
	addi $a0, $a0, 5		# 0x40000000
	jal subtract_three		# 0x40000004
.end main

subtract_three:
	addi $sp, $sp, -4		# 0x40000008
	sw $ra, ($sp)			# 0x4000000c

	jal subtract_one		# 0x40000010
	addi $v0, $v0, -2		# 0x40000014

	lw $ra, ($sp)			# 0x40000018
	addi $sp, $sp, 4		# 0x4000001c
	jr $ra					# 0x40000020
.end subtract_three

subtract_one:
	addi $sp, $sp, -4		# 0x40000024
	sw $ra, ($sp)			# 0x40000028

	add $v0, $a0, $zero		# 0x4000002c
	addi $v0, $v0, -1		# 0x40000030

	lw $ra, ($sp)			# 0x40000034
	addi $sp, $sp, 4		# 0x40000038
	jr $ra					# 0x4000003c
.end subtract_one

