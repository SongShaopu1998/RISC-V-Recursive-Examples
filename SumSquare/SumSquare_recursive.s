.data
n: .word 1

.text
main:
    la t0, n
    lw a0, 0(t0)
    # call fib
    jal SumSquare
    
    # final result in a1
    add a1, a0, x0
    addi a0, x0, 1
    
    ecall # print integer ecall
    addi a0, x0, 10
    ecall # terminate ecall
SumSquare:
    addi sp, sp, -8
    # save the function argument
    # callee
    sw s0, 0(sp)
    # caller
    sw ra, 4(sp)
    li t0, 1
    bgt a0, t0, else
    # free the stack space
    j exit
#     jr ra

else:
	mul s0, a0, a0
    # Before going into the next function call, 
    # we must store it in the stack, just like the fib(n - 1)
    # While s0 is a Callee reg, so we give this task to the next
    # function call
#     sw s0, 0(sp)

    # call SumSquare(n - 1)
    addi a0, a0, -1
    jal SumSquare

    add a0, s0, a0
    
exit:
	lw ra, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    jr ra