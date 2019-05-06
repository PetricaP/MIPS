main:
	addi $a0, $zero, 6		# 0x40000000 20040003
	jal fibonacci			# 0x40000004 0c00000c
	j 0xffffff				# 0x40000008 08ffffff
.end main

fibonacci:
	addi $sp, $sp, -8		# 0x4000000c 23bdfff8
	sw $ra, ($sp)			# 0x40000010 afbf0000

	addi $t0, $zero, 1		# 0x40000014 20080001
	beq $a0, $t0, return_1	# 0x40000018 1104000d
	addi $t0, $zero, 2		# 0x4000001c 20080002
	beq $a0, $t0, return_1	# 0x40000020 1104000b
# a0 is not 1 and is not 2
	addi $a0, $a0, -1		# 0x40000024 2084ffff
	sw $a0, 4($sp)			# 0x40000028 afa40004
	jal fibonacci			# 0x4000002c 0c00000c

	lw $a0, 4($sp)			# 0x40000030 8fa40004
	addi $a0, $a0, -1		# 0x40000034 2084ffff

	sw $v0, 4($sp)			# 0x40000038 afa40004

	jal fibonacci			# 0x4000003c 0c00000c

	lw $t0, 4($sp)			# 0x40000040 8fa80004
	add $v0, $t0, $v0		# 0x40000044 01024020
	j exit					# 0x40000048 08000054
return_1:
	addi $v0, $zero, 1		# 0x4000004c 20020001
exit:
	lw $ra, ($sp)			# 0x40000050 8fbf0000
	addi $sp, $sp, 8		# 0x40000054  23bd0008
	jr $ra					# 0x40000058 03e00008
.end fibonacci
