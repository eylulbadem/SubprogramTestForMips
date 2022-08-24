##
##	CS224 - Lab 2
##	Section 3 
##	Eylül Badem - 22003079
##	08.03.2022
##
## Lab2.asm  tests subprograms for bubble sort and digit sum
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
	
	la 	$t0,arr 		# array starts at register t0 now
	la 	$t1,arrSize		# array size is stored in t1
	addi 	$s2,$zero,0
	
	jal 	createArray
	
	addi 	$sp $sp -4
    	sw 	$s0 0($sp)
    	
    	jal printArray
	
	lw 	$s0 0($sp)
	addi 	$sp $sp 4
	
	#----------------
	
	la 	$a0,endl		# endl string
	li 	$v0,4			# syscall 4 prints the string
	syscall
    	
	j 	bubbleSort
	
	toMain:
	li 	$v0,10
	syscall
	
#----------------------------------------------------------------------

createArray:
	
	askingSize:	
	la 	$a0,askSize		# ask the array size to user on terminal
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,5           	# reads the size for the array        
    	syscall
    
    	move 	$s1,$v0
    	mul 	$s3,$s1,4     		# change size into bytes
    	la 	$a0,($s3)         	# allocate the size of the array in the heap
    	li 	$v0,9           	# now, $v0 has the address of allocated memory
    	syscall
		
    	move 	$s0,$v0         	
    	beq 	$s1,$zero,here
    	addi 	$sp,$sp,-4
    	sw 	$s0,0($sp)
    		
	askingElm:	
	la 	$a0,askElement		# asks the next element to user on terminal
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	li 	$v0,5			# syscall 5 takes an integer from the user
	syscall
	
	sw 	$v0,0($s0)		# store the element in the first byte of s0
	addi 	$s0,$s0,4		# skip to the next byte of s0
	addi 	$s2,$s2,1		# increase count
	
	blt 	$s2,$s1,askingElm 	# if size is less than arrSize, ask for the next element
	
	lw 	$s0,0($sp)
	addi 	$sp,$sp,4
	
	here:
	la 	$a0,array		# array string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0,$s0
	move 	$a1,$s1
	
	addi 	$s2,$zero,0
	
	jr $ra

bubbleSort: 

    	addi 	$sp,$sp,-4
    	sw 	$s0,0($sp)
    	
	addi 	$s2,$zero,0
	addi 	$s6,$zero,0
	move	$s4,$s1
	addi	$s5,$s1,-1
    	
	first:
	addi 	$s2,$zero,0
	addi 	$s4,$s4,-1              # decreasing the size for second loop

	addi 	$sp,$sp,-4
    	sw 	$s0,0($sp)
    	
	second:
    	bge 	$s2,$s4,endOfSecond
	lw 	$a1,0($s0)              
    	addi 	$s0,$s0,4               
    	lw 	$a2,0($s0)              
    	addi 	$s2,$s2,1               

    	slt 	$a3,$a1,$a2             
    	bne 	$a3,$zero,skipSwitch
   
    	switch:
      	lw 	$a0,0($s0)
      	lw 	$a1,-4($s0)
      	sw 	$a1,0($s0)
      	sw	$a0,-4($s0)
	
    	skipSwitch:
    	j second 
    	
    	endOfSecond:
    	
	lw 	$s0,0($sp)
	addi 	$sp,$sp,4
	
    	addi 	$s6,$s6,1              
    	bge	$s6,$s5,justEnd
  	j first          		
  	
  	justEnd:
	la 	$a0,sorted		# space string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	move 	$a0,$s0
	move 	$a1,$s1
	addi 	$s2,$zero,0
	
	lw 	$s0,0($sp)
	addi 	$sp,$sp,4
	
    	addi 	$sp,$sp,-4
    	sw 	$s0,0($sp)
    	
	jal printArray
	
	lw 	$s0,0($sp)
	addi 	$sp,$sp,4
	
	la 	$a0,endl		# endl string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	jal 	processSortedArray
	
	j toMain
	
processSortedArray:
	
	la 	$a0,processed		# processed string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	begin:
	
	la 	$a0,endl		# endl string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	addi 	$s2,$s2,1		
	
	la 	$a0,0($s2)		# index position
	li 	$v0,1			# syscall 4 prints the string
	syscall
	
	la 	$a0,space		# space string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	lw 	$s5,0($s0)		# load the first value of the array in s5 
	
	la 	$a0,0($s5)		# the stored element 
	li 	$v0,1			# syscall 1 prints an integer
	syscall
	
	la 	$a0,space		# space string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	j sumDigits
	
	here20:
	addi 	$s0,$s0,4	
	blt 	$s2,$s1,begin		# stop printing elements if number of printing reaches the array size
	
	jr $ra
	
sumDigits:
	lw $s4,0($s0)
	li $s3,0
	li $s6,10
	
	loop:
	div $s4,$s6
	mfhi $s7
	add $s3,$s3,$s7
	mflo $s4
	bgt $s4,$zero,loop
	
	la 	$a0,0($s3)		# space string
	li 	$v0,1			# syscall 4 prints the string
	syscall
	
	j here20
	
printArray:

	beq 	$s2,$s1,done		# stop printing elements if number of printing reaches the array size
	
	lw 	$s5,0($s0)		# store the first value of the array in t5 temporarily
	addi 	$s2,$s2, 1		# increase count
	
	la 	$a0,0($s5)		# the stored element 
	li 	$v0,1			# syscall 1 prints an integer
	syscall
	
	addi 	$s0,$s0,4		# skip to the next byte of t6
	
	la 	$a0,space		# space string
	li 	$v0,4			# syscall 4 prints the string
	syscall
	
	j printArray			# repeat the loop unconditionally
	
	done:
	
	addi 	$s2,$zero,0
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
array: 		.asciiz "Original array: "
sorted: 	.asciiz "Bubble sorted in ascending order: "
processed: 	.asciiz "Processed: "

askSize:	.asciiz "Enter array size: "
askElement:	.asciiz "Enter element: "

arr:		.space 400
arrSize: 	.word 4

##
## end of file Lab2.asm 
