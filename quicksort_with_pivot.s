	.data
arr:		.space		40
size:		.space		4
textbef:	.asciiz		"Original list: "
textaft:	.asciiz 	"After Quicksort : "
blank:		.asciiz 	" "
newline:	.asciiz 	"\n"

	.text
	.globl main
main:
input:
	beq 	$t0, 40, ex
	li 		$v0, 5
	syscall
		
	sw 		$v0, arr($t0)
	addi 	$t0, $t0, 4
	j input

ex:	

	la		$t0, size
	la		$t1, arr
	sub		$t2, $t0, $t1
	srl		$t2, $t2, 2
	sw		$t2, 0($t0)
	
	li		$v0, 4
	la		$a0, textbef
	syscall

	jal		printarr
	
	la		$a0, arr
	li		$a1, 0

	lw		$t0, size
	addi	$t0, $t0, -1
	move	$a2, $t0
	
	jal		quicksort

	li 		$v0, 4
	la 		$a0, newline
	syscall
	
	li		$v0, 4
	la		$a0, textaft
	syscall

	jal		printarr

	li		$v0, 10
	syscall

printarr:

	la		$s0, arr
	lw		$t0, size
loop1:
	beq		$t0, $zero, loop1_done
	
	li		$v0, 4
	la		$a0, blank
	syscall
	
	li		$v0, 1
	lw		$a0, 0($s0)
	syscall
	
	addi	$t0, $t0, -1
	addi	$s0, $s0, 4
	
	j		loop1
	
loop1_done:
	
	li		$v0, 4
	la		$a0, newline
	syscall
	jr		$ra

quicksort:

	addi	$sp, $sp, -24	
	sw		$s0, 0($sp)		
	sw		$s1, 4($sp)		
	sw		$s2, 8($sp)		
	sw		$a1, 12($sp)	#first element
	sw		$a2, 16($sp)	#size-1	
	sw		$ra, 20($sp)	

	move	$s0, $a1		#left=0 for first tym
	move	$s1, $a2		#right n-1
	move	$s2, $a1		#left


loop_quick1: 				# while (l < r)
	bge		$s0, $s1, loop_quick1_done
	

loop_quick1_1: 				# while (arr[l] <= arr[p] && l < right)
	li		$t7, 4			# t7 = 4
	
	mult	$s0, $t7
	mflo	$t0			
	add		$t0, $t0, $a0	# t0 = &arr[l]
	lw		$t0, 0($t0)
							
	mult	$s2, $t7	
	mflo	$t1			
	add		$t1, $t1, $a0	# t1 = &arr[p]

	lw		$t1, 0($t1)		#first element is pivot
	
	addi 	$sp, $sp, -12
	sw 		$a0, 0($sp)
	sw 		$v0, 4($sp)
	sw 		$t1, 8($sp)
	move 	$v0, $t1
	move 	$a0, $v0
	li 		$v0, 1
	syscall
	li 		$v0, 4
	la 		$a0, blank
	syscall
	lw		$a0, 0($sp)
	lw  	$v0, 4($sp)		
	lw		$t1, 8($sp)
	addi    $sp, $sp, 12	

	bgt		$t0, $t1, loop_quick1_1_done		# check arr[l] <= arr[p]
												
	bge		$s0, $a2, loop_quick1_1_done		# check l < right
												
	addi	$s0, $s0, 1							# l++
	j		loop_quick1_1
	
loop_quick1_1_done:

												
loop_quick1_2:				# while (arr[r] >= arr[p] && r > left)
	li		$t7, 4			# t7 = 4
												
	mult	$s1, $t7							
	mflo	$t0				
	add		$t0, $t0, $a0	# t0 = &arr[r]
	lw		$t0, 0($t0)
											
	mult	$s2, $t7		# t1 = &arr[p]
	mflo	$t1				
	add		$t1, $t1, $a0	
	lw		$t1, 0($t1)
	addi 	$sp, $sp, -12
	sw 		$a0, 0($sp)
	sw 		$v0, 4($sp)
	sw 		$t1, 8($sp)
	move 	$v0, $t1
	move 	$a0, $v0
	li 		$v0, 1
	syscall
	li 		$v0, 4
	la 		$a0, blank
	syscall
	lw		$a0, 0($sp)
	lw  	$v0, 4($sp)		
	lw		$t1, 8($sp)
	addi    $sp, $sp, 12
												
	blt		$t0, $t1, loop_quick1_2_done		# check arr[r] >= arr[p]
	
	ble		$s1, $a1, loop_quick1_2_done		# check r > left
									
	addi	$s1, $s1, -1		# r--
	j		loop_quick1_2
	
loop_quick1_2_done:

												
	blt		$s0, $s1, If_quick1_jump			# if (l >= r)
# swapping (arr[p], arr[r])
	li		$t7, 4			# t7 = 4
							
	mult	$s2, $t7		# t0 = &arr[p]
	mflo	$t6		
	add		$t0, $t6, $a0
							
	mult	$s1, $t7		# t1 = &arr[r]
	mflo	$t6			
	add		$t1, $t6, $a0	
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
# quick(arr, left, r - 1)
	
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = r - 1
	jal		quicksort
							#pop stack
	lw		$a1, 12($sp)	
	lw		$a2, 16($sp)	
	lw		$ra, 20($sp)	
	
# quick(arr, r + 1, right)
	
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1 = r + 1
	jal		quicksort

	lw		$a1, 12($sp)	
	lw		$a2, 16($sp)
	lw		$ra, 20($sp)
	
# return
	lw		$s0, 0($sp)	
	lw		$s1, 4($sp)	
	lw		$s2, 8($sp)	
	addi	$sp, $sp, 24	
	jr		$ra

If_quick1_jump:

# swapping (arr[l], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t6				
	add		$t0, $t6, $a0	# t0 = &arr[l]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6			
	add		$t1, $t6, $a0	# t1 = &arr[r]

	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		loop_quick1
	
loop_quick1_done:
	
# return

	lw		$s0, 0($sp)	
	lw		$s1, 4($sp)	
	lw		$s2, 8($sp)	
	addi	$sp, $sp, 24
	jr		$ra
