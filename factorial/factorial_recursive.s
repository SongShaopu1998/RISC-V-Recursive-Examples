.globl factorial

.data
n: .word 1

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial
	
    # the argument given to the system stores in a1, a2, ...
    addi a1, a0, 0
    # store the system call number in a0 in Venus, a7 in Linux
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi sp, sp, -8
    # return address
    sw ra, 0(sp)
    # current n value
    sw a0, 4(sp)
    li t1, 1
    # if (n <= 1)
    bgt a0, t1, else
    # return to caller
    j exit

else:
	addi a0, a0, -1
    # call factorial
    jal factorial
    # n * factorial(n - 1)
    lw t1, 4(sp)
#     lw ra, 0(sp)
    mul a0, t1, a0

exit:
	lw ra, 0(sp)
    addi sp, sp, 8
    jr ra