.globl main

    .data
msg: .asciiz "Enter a non-negative number: "

    .text
main:
    li $v0,  4
    la $a0,  msg        #prints 
    syscall             
    li $v0,  5          #take input
    syscall       

    move $a0, $v0       #store the value 

    jal fibonacci  

    move $a0, $v0

    li  $v0, 1
    syscall

    li $v0, 10
    syscall

fibonacci:
    addi $sp, $sp, -12 
    sw   $ra, 0($sp)
    sw   $s0, 4($sp)
    sw   $s1, 8($sp)

    move $s0, $a0

    beq  $s0, 0, r0
    beq  $s0, 1, r1

    addi $a0, $s0, -1

    jal fibonacci

    move $s1, $v0
    addi $a0, $s0, -2

    jal fibonacci                 

    add $v0, $v0, $s1         

exit:
    lw   $ra, 0($sp)
    lw   $s0, 4($sp)
    lw   $s1, 8($sp)
    addi $sp, $sp, 12      
    jr $ra

r1:
    li $v0, 1
    j exit

r0:     
    li $v0, 0
    j exit
