.data
n: .word 0
MAX: .word 31
cache:
	.word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0

.text
main:
	# ---PROLOGUE---
	addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    # ---PROLOGUE---
    
    la t3, n
    # argument n
    lw a0, 0(t3)
    
    la t2, MAX
   	# max
    lw s1, 0(t2)
    
    # cache[]
    la s2, cache
    # i
    li t0, 0
    
# use this loop to set all elements in cache[] to -1
loop:
	# if i == MAX
	beq t0, s1, finish_loop
    # i << 2
	slli t1, t0, 2
    # &cache[i]
    add t2, s2, t1
    # cache[i]
    lw t1, 0(t2)
    # 0-1 = -1
    addi t1, t1, -1
    # set to -1
    sw t1, 0(t2)
    # ++i
    addi t0, t0, 1
    j loop
    
finish_loop:
    # call fib
    jal fib
    
    # ---EPILOGUE---
#     lw a0, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 12
    # ---EPILOGUE---
    
    # final result in a1
    add a1, a0, x0
    addi a0, x0, 1
    
    ecall # print integer ecall
    addi a0, x0, 10
    ecall # terminate ecall
    
fib:
    addi sp, sp, -16
    # store the return address & current n (this function caontins call to another function)
    sw ra, 0(sp)
    # save the function arguments (this function caontins call to another function)
    sw a0, 4(sp)
    # we will use s0 in this function (s0 is a Callee reg)
    sw s0, 8(sp)
    # hold cache pointer
    sw s2, 12(sp)
    
    # if case (n == 0 || n == 1)
    li t0, 1
    ble a0, t0, exit
    # else if (n > 1), we call find
    jal find
    # now, a0 stores the cache[num], if it's -1, we need to preform actual function call
    li t0, -1
    beq a0, t0, else
    # else, we just return a0 (cache[num])
    j exit

else:
	# load a0 from stack
	lw a0, 4(sp)
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
    
    # set cache[n] to this value
    lw t0, 4(sp)
    slli t1, t0, 2
    la s2, cache
    add t2, s2, t1
    sw a0, 0(t2)

exit:
	lw s2, 12(sp)
    lw s0, 8(sp)
    # NOTE we cannot load the a0, since it already keep the result
    lw ra, 0(sp)
    addi sp, sp, 16
    jr ra

# before calling this function, argument will be put in a0
find:
	# PROLOGUE
	addi sp, sp, -4
    sw s2, 0(sp)
    
	la s2, cache
    slli t0, a0, 2
    add t1, s2, t0
    # return value
    lw a0, 0(t1)
    
    # EPILOGUE
    lw s2, 0(sp)
    addi sp, sp, 4
    
    # return to caller
    jr ra