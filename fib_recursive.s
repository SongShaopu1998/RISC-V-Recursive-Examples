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
    addi sp, sp, -12
    # store the return address & current n (this function caontins call to another function)
    sw ra, 0(sp)
    # save the function arguments (this function caontins call to another function)
    sw a0, 4(sp)
    # we will use s0 in this function (s0 is a Callee reg)
    sw s0, 8(sp)
    
    # if case (n == 0 || n == 1)
    li t0, 1
    bgt a0, t0, else
    # in the 0/1 case: free the memory of stack
    j exit

else:
    # n - 1
    addi a0, a0, -1

    # call fib(n - 1)
    jal fib

    # after this call, what a0 stores has become the return value
    # of fib(n - 1)
    # since we still use a0 to store arguments in the fib(n - 2) call,
    # we need to store the fib(n - 1) value first

    mv s0, a0
    
    # to calculate n - 2, we load the a0 from stack, which is the 'n'
    lw a0, 4(sp)
    
    # n - 2
    addi a0, a0, -2

    # call fib(n - 2)
    jal fib
    
    # fib(n - 2) result in a0, fib(n - 1) in s0
    # fib(n - 1) + fib(n - 2)

    add a0, s0, a0

exit:
    lw s0, 8(sp)
    # NOTE we cannot load the a0, since it already keep the result
    lw ra, 0(sp)
    addi sp, sp, 12
    jr ra
