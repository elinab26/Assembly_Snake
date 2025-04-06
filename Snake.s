.section .data
snake_x: .long 45  #the head position
snake_y: .long 44
width: .long 10
height: .long 20
grid: .space 100, 0x20    #reserve 10x10 bytes for the grid


.section .text
.globl main
.type	main, @function 

main:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15
    pushq %r14

    #initialize r15 to save him as a counter for the number of lines
    xorq %r15, %r15

    //print the whole grid
    line_loop:
        incl %r15d
        call print
        cmpl width, %r15d
        jne line_loop

    print_last:
        #print the last line of '-'
        movq $'-', %rdi
        pushq %rdi
        
        xorq %r15, %r15
        //double the size to print the '-'
        movl width, %r15d
        shll $2, %r15d
        incl %r15d
        xorq %r14, %r14
        last_line:
            incl %r14d
            //syscall to print the '-'
            movq $1, %rax
            movq $1, %rdi
            movq %rsp, %rsi
            movq $1, %rdx
            syscall

            //print it 20 times
            cmpl %r14d, %r15d
            jne last_line

        call print_new_line

    popq %rdi
    popq %r14
    popq %r15
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
    movl width, %r15d
    shll $2, %r15d
    incl %r15d

    //save '-' in the stack to print it
    movq $'-', %rdi
    pushq %rdi
    //save '|' in the stack to print it
    movq $'|', %rdi
    pushq %rdi
    line_print:
        incl %r14d
        //syscall to print the '-'
        movq $1, %rax
        movq $1, %rdi
        leaq 8(%rsp), %rsi
        movq $1, %rdx
        syscall

        //print it 20 times
        cmpl %r14d, %r15d
        jne line_print

        call print_new_line

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

        cmpl height, %r13d
        jne print_content
        movq $1, %rax
        movq $1, %rdi
        movq %rsp, %rsi
        movq $1, %rdx
        syscall

        call print_new_line

    //pop '-', '|' from the stack
    popq %rdi
    popq %rdi
    popq %r12
    popq %r13
    popq %r14
    popq %r15
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
