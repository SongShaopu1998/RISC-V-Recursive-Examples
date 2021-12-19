.data
n: .word 12

.text
main:
    la t3, n
    lw a0, 0(t3)
    # call fib
    jal fib
    
    # fianl result in a1
    add a1, a0, x0
    addi a0, x0, 1
    
    ecall # print integer ecall
    addi a0, x0, 10
    ecall # terminate ecall
fib:
	addi sp, sp, -8
    # store the return address & current n
    sw ra, 0(sp)
    # save the current N's copy
    sw a0, 4(sp)
    
    # if case (n == 0 || n == 1)
    li t0, 1
    bgt a0, t0, else
    # in the 0/1 case: free the memory of stack
    addi sp, sp, 8
    jr ra

else:
	# n - 1
	addi a0, a0, -1
    # call fib(n - 1)
    jal fib
    # to calculate n - 2, we must save a copy of N before
    # and we also need to save the current result fib(n - 1)
    # t0 is n
	lw t0, 4(sp)
    # a0 stores the current result
    sw a0, 4(sp)
    # n - 2
    addi a0, t0, -2
    # call fib(n - 2)
    jal fib
    # fib(n - 1) + fib(n - 2)
    # t0 is fib(n - 1)
    lw t0, 4(sp)
    # restore ra
    lw ra, 0(sp)
    addi sp, sp, 8
    # result in a0
    add a0, t0, a0
    # return to the caller
    jr ra
    
    