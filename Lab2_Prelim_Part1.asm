##
##	CS224 - Lab 2, Preliminery, Part 1
##	Section 3 
##	Eylül Badem - 22003079
##	04.03.2022
##
## Lab2_Prelim_Part1.asm  tests subprograms for circular shift operations.
##
##	v0 - reads user input
##	t0 - holds array
##	a0 - points to output
##

###############################
#				#
#	text segment		#
#				#
###############################

	.text		
	.globl __start	

__start: 				# execution starts here
	la 	$t0,input		# t0 points to the input
	la 	$t1, bits		# t1 points to the number of bytes to shift
	la 	$t3, leftResult
	la 	$t4, rightResult
	addi 	$t2,$zero,0		# setting t2 (counter) to zero
	addi 	$s5,$zero,32
	
	la 	$a0,askInput		# ask the input to user on terminal
	la 	$a1,9
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,5  			# syscall 5 takes an integer from the user
	syscall
	
	sw 	$v0,0($t0)		# input updated
	
askingBits:
	la 	$a0,askBits		# ask the number of bits to shift to user on terminal
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,5			# syscall 5 takes an integer from the user
	syscall
	
	bgt 	$v0,32,askingBits	# if bit number is more than 8, ask again 
	sw 	$v0,0($t1)		# bit number updated

program:
	lw 	$a0, 0($t0) 
	lw 	$a1, 0($t1) 
	
	jal 	shiftLeftCircular
	
	move 	$a0, $v0 
	li 	$v0, 34 		# $v0 34 prints hexadecimal value           
	syscall
	
	la 	$a0,endl
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	lw 	$a0, 0($t0) 
	lw 	$a1, 0($t1) 
	
	jal 	shiftRightCircular
	
	move 	$a0, $v0 
	li 	$v0, 34 		# $v0 34 prints hexadecimal value         
	syscall
	
	li 	$v0,10			# system call to exit
	syscall				# bye bye
	
#----------------------------------------------------------------------

shiftLeftCircular:
	addi 	$s2,$zero,0		# counter
	move 	$s3,$a0
start1:
	sll 	$s3,$s3,1 
	addi 	$s2,$s2,1		# increase count
	bne 	$s2,$a1,start1		# repeat loop until number of shifts are the desired number
	move 	$v0,$s3
	
	move 	$s3,$a0
	addi 	$s2,$zero,0		# counter
	sub 	$s7,$s5,$a1
start2:
	srl 	$s3,$s3,1 
	addi 	$s2,$s2,1		# increase count
	bne 	$s2,$s7,start2		# repeat loop until number of shifts are the desired number
	
	move 	$v1,$s3
	
	or 	$v0,$v1,$v0
	
	jr 	$ra

shiftRightCircular:
	addi 	$s2,$zero,0		# counter
	move 	$s4,$a0
start3:
	srl 	$s4,$s4,1 
	addi 	$s2,$s2,1		# increase count
	bne 	$s2,$a1,start3		# repeat loop until number of shifts are the desired number
	move 	$v0,$s4
	
	move 	$s4,$a0
	addi 	$s2,$zero,0		# counter
	sub 	$s7,$s5,$a1
start4:
	sll 	$s4,$s4,1 
	addi 	$s2,$s2,1		# increase count
	bne 	$s2,$s7,start4		# repeat loop until number of shifts are the desired number
	
	move 	$v1,$s4
	
	or 	$v0,$v1,$v0
	
	jr 	$ra
	
###############################
#				#
#     	 data segment		#
#				#
###############################

	.data
space: 		.asciiz " "
endl:		.asciiz "\n"
line: 		.asciiz "------------------------ \n"
bits: 		.word 4
input: 		.word 32
leftResult: 	.word 32
rightResult:	.word 32
askBits: 	.asciiz "Enter number of bits to shift: "
askInput:	.asciiz "Enter the integer to be shifted: "
result1:	.asciiz "Left Sihft (SLC): "
result2:	.asciiz "Right Sihft (SRC): "

##
## end of file Lab2_Prelim_Part1.asm 
