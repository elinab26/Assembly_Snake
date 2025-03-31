.section .data
snake_x: .long 45  #the head position
snake_y: .long 44
size: .long 10
grid: .space 100, 0x20    #reserve 10x10 bytes for the grid


.section .text
.globl main
.type	main, @function 

main:
    pushq %rbp
    movq %rsp, %rbp

    call print

    movq %rbp, %rsp
    popq %rbp
    movq $60, %rax
    movq $0, %rdi
    syscall

print:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15
    pushq %r14
    pushq %r13
    pushq %r12

    //initialize %r12 and save in him the address of the grid
    xorq %r12, %r12
    movq $grid, %r12
    //initialize r14 to use him as line counter
    xorq %r14, %r14

    //initialize r13 to use him as grid counter
    xorq %r13, %r13

    //double the size to print the '-'
    movl size, %r15d
    shll $1, %r15d
    
    //save '-' in the stack to print it
    movq $'-', %rdi
    pushq %rdi
    line_print:
        incl %r14d
        //syscall to print the '-'
        movq $1, %rax
        movq $1, %rdi
        movq %rsp, %rsi
        movq $1, %rdx
        syscall

        cmpl %r14d, %r15d
        jne line_print
        popq %rdi

        call print_new_line

    //save '|' in the stack to print it
    movq $'|', %rdi
    pushq %rdi
    print_content:
        incl %r13d
        movq $1, %rax
        movq $1, %rdi
        movq %rsp, %rsi
        movq $1, %rdx
        syscall

        //print the content of the grid
        movq $1, %rax
        movq $1, %rdi

        movq %r12, %rsi
        movq $1, %rdx
        syscall
        incq %r12

        cmpl size, %r13d
        jne print_content
        movq $1, %rax
        movq $1, %rdi
        movq %rsp, %rsi
        movq $1, %rdx
        syscall
        popq %rdi

        call print_new_line

    movq %rbp, %rsp
    popq %rbp
    ret

print_new_line:
    pushq %rbp
    movq %rsp, %rbp
    
    //save '\n' to the stack to print it
    movq $'\n', %rdi
    pushq %rdi
    movq $1, %rax
    movq $1, %rdi
    movq %rsp, %rsi
    movq $1, %rdx
    syscall
    popq %rdi

    movq %rbp, %rsp
    popq %rbp
    ret
