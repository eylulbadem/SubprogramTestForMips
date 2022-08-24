##
##	CS224 - Lab 2, Preliminery, Part 2
##	Section 3 
##	Eylül Badem - 22003079
##	04.03.2022
##
## Lab2_Prelim_Part2.asm  tests subprograms array operations.
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
	
	la 	$t0, arr 		# array starts at register t0 now
	la 	$t1, arrSize		# array size is stored in t1
	addi 	$s2,$zero,0
	
	jal 	createArray
	
	jal 	arrayOperations
	
print:
	la 	$a0,minStr
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0, $s5 
	li 	$v0, 1 			# $v0 34 prints hexadecimal value           
	syscall
	
	la 	$a0,endl
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	#-----------
	
	la 	$a0,maxStr
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0, $s6 
	li 	$v0, 1 			# $v0 34 prints hexadecimal value           
	syscall
	
	la 	$a0,endl
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	#-----------
	
	la 	$a0,sumStr
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0, $s7 
	li 	$v0, 1 			# $v0 34 prints hexadecimal value           
	syscall
	
	la 	$a0,endl
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	#-----------
	
	la 	$a0,palindStr
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0, $s3 
	li 	$v0, 1 			# $v0 34 prints hexadecimal value           
	syscall
	
	la 	$a0,endl
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,10			# system call to exit
	syscall				# bye bye
	
#----------------------------------------------------------------------

createArray:
	
	askingSize:	
	la 	$a0,askSize		# ask the array size to user on terminal
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0, 5           	# reads the size for the array        
    	syscall
    
    	move 	$s1,$v0
    	mul 	$s3, $s1, 4     	# because array contains integer, I change them into bytes
    	la 	$a0, ($s3)         	# allocate the size of the array in the heap
    	li 	$v0, 9           	# now, $v0 has the address of allocated memory
    	syscall
		
    	move 	$s0,$v0         	
    	beq 	$s1,$zero,here
    	addi 	$sp $sp -4
    	sw 	$s0 0($sp)
    		
	askingElm:	
	la 	$a0,askElement		# asks the next element to user on terminal
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,5			# syscall 5 takes an integer from the user
	syscall
	
	sw 	$v0,0($s0)		# store the element in the first byte of s0
	addi 	$s0,$s0, 4		# skip to the next byte of s0
	addi 	$s2,$s2, 1		# increase count
	
	blt 	$s2,$s1,askingElm 	# if size is less than arrSize, ask for the next element
	
	lw 	$s0 0($sp)
	addi 	$sp $sp 4
	
	here:
	move 	$a0,$s0
	move 	$a1,$s1
	
	jr 	$ra 
	
arrayOperations:
	move 	$s1,$a1
	move 	$s0,$a0
	move 	$s5,$s0
	move 	$s6,$s0
	move 	$s7,$s0
	
	lw 	$s3,0($s5)		# Get the next element to be added
min:
	beq 	$s1,0,zero1		
	beq 	$s1,1,one1		
	j cont1
	
	zero1:
	li 	$s3,0
	j go1
	
	one1:
	lw 	$s3,0($s5)
	j go1
	
	cont1:
	addi	$s5,$s5,4		# Update array pointer $t0
	lw 	$s4,0($s5)		# Get the next element to be added
	addi	$s1,$s1,-1
	bge	$s3,$s4,first
	j done1
	
	first:
	move	$s3,$s4
	
	done1:
	bgt	$s1,1,cont1		# Are we done: proccessed all elements?
	
	go1:
	move 	$s5,$s3	
	
	addi	$s4,$zero,0

	move 	$s1,$a1
	lw 	$s3,0($s6)		# Get the next element to be added
max:
	beq 	$s1,0,zero2		
	beq 	$s1,1,one2		
	j cont2
	
	zero2:
	li 	$s3,0
	j go2
	
	one2:
	lw 	$s3,0($s6)
	j go2
	
	cont2:
	addi	$s6,$s6,4		# Update array pointer $t0
	lw 	$s4,0($s6)		# Get the next element to be added
	addi	$s1,$s1,-1
	ble	$s3,$s4,second
	j done2
	
	second:
	move	$s3,$s4
	
	done2:
	bgt	$s1,1,cont2		# Are we done: proccessed all elements?
	
	go2:
	move 	$s6,$s3	
	
	addi	$s4,$zero,0
	move 	$s1,$a1
	move 	$s7,$a0
sum:
	beq 	$s1,0,zero3		
	beq 	$s1,1,one3		
	j cont3
	
	zero3:
	li 	$s4,0
	j go3
	
	one3:
	lw 	$s4,0($s7)
	j go3
	
	cont3:
	lw	$s3,0($s7)		# Get the next element to be added
	add	$s4,$s4,$s3		# sum = sum + $s3
	addi	$s1,$s1,-1
	addi	$s7,$s7,4		# Update array pointer $t0
	bgt	$s1,$zero,cont3		# Are we done: proccessed all elements?	

	go3:
	move 	$s7,$s4	
	move 	$s1,$a1
palindrome:
	beq	$s1,0,yes		# no need to check equality of elements if there are no elements, skip to print true 
	beq 	$s1,1,yes		# no need to check equality of elements if there is only one element, skip to print true 
	addi 	$s2,$zero,2		# clear s2 (counter)
	div  	$s1,$s2
	mflo 	$s4
	addi 	$s2,$zero,0		# clear s2 (counter)

	switch:
	addi 	$a0,$a0,4		
	addi 	$s2,$s2,1		# increase count
	bne 	$s2,$s1,switch		
	
	addi 	$s2,$zero,0		# clear s2 (counter)
	addi 	$a0,$a0,-4		# skip to the previous byte of a0
	
	loop:
	lw 	$a2,0($s0)		# load the last value of the mini array in a2 temporarily
	lw 	$a3,0($a0)		# load the last value of the array in a3 temporarily
	bne 	$a2,$a3,no		# compare the elements 
	addi 	$s2,$s2,1		# increase count
	addi 	$s0,$s0,4		# skip to the previous byte of s0
	addi 	$a0,$a0,-4		# skip to the previous byte of a0
	
	bne 	$s2,$s4,loop		# repeat loop until number of comparing reaches half of the array size

	yes:
	li 	$s3,1	
	j thisExit			# already executed yes, so skip no
	
	no:
	li 	$s3,0
	
	thisExit:
	jr 	$ra			# return to where you left the code
	
###############################
#				#
#     	 data segment		#
#				#
###############################

	.data
space: .asciiz " "
endl:	.asciiz "\n"
line: .asciiz "------------------------ \n"
askSize:	.asciiz "Enter array size: "
askElement:	.asciiz "Enter element: "
minStr:	.asciiz "Min: "
maxStr:	.asciiz "Max: "
sumStr:	.asciiz "Sum: "
palindStr:	.asciiz "Is palindrome?: "
arr:	.space 400
arrSize: .word 4

##
## end of file Lab2_Prelim_Part2.asm 
