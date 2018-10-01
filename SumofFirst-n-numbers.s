    .globl main #assembler direcetive

    .data

pop:     .asciiz  "Enter n:"
r1:    .asciiz  "Sum of the first "
r2:    .asciiz  " integers is "
nl:    .asciiz  "\n"
      
    .text

main:
    li      $v0, 4       
    la      $a0, pop
    syscall

    li      $v0, 5        
    syscall
    move    $s0, $v0

    li      $s1, 0          
    li      $s2, 0         
for:
    blt     $s0, $s2, endf  
    add     $s1, $s1, $s2   
    add     $s2, $s2, 1   
    b       for           
endf:
    li      $v0, 4         
    la      $a0, r1
    syscall

    li      $v0, 1        
    move    $a0, $s0
    syscall

    li      $v0, 4      
    la      $a0, r2
    syscall

    li      $v0, 1       
    move    $a0, $s1
    syscall

    li      $v0, 4      
    la      $a0, nl
    syscall
    li      $v0, 4
    la      $a0, nl
    syscall

    li      $v0, 10       
    syscall
      
