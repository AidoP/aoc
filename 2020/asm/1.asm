.global main

times:
    .string " * "
equals:
    .string " = "

main:
    li s0, -1
    li s1, -1

    # allocate persistent stacks for 2 iterators
    addi sp, sp, -24
    mv a0, sp
    call init_iter_input
    addi a0, sp, 12
    call init_iter_input

    0:
        mv a0, sp
        call iter_input
        li t0, -1
        beq a0, t0, 1f
        lla a1, number_str
        call format_uint
        call println
        j 0b
    1:

    li a0, 420
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call print

    lla a0, times
    call print

    li a0, 86
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call print

    lla a0, equals
    call println
    li a0, 0
    call exit

init_iter_input:
    # Get the input string length, and the address of the string
    lw t0, input
    sw t0, 0(a0)
    lla t1, input
    addi t1, t1, 4
    sw t1, 4(a0)

    ret

# Iterate over the next line of input
# a0 - pointer to persistent stack of the persistent function
# returns
# a0 - the integer parsed from the input, or -1 if EOF
iter_input:
    # Change stack space to the persistent memory segment
    mv s0, sp
    mv sp, a0
    # Store return address
    sw ra, 8(sp)
    
    # Load registers from the stack
    lw t0, 0(sp)
    lw t1, 4(sp)

    # Nothing left to read
    beqz t0, 1f

    # Read in the next integer
    mv a0, t1
    li a1, '\n'
    call parse_uint

    # Load registers from the stack after a function call
    lw t0, 0(sp)
    lw t1, 4(sp)

    # Advance the position of the string by the amount read + 1
    add t1, t1, a1
    addi t1, t1, 1
    sub t0, t0, a1
    addi t0, t0, -1

    j 2f

    1:
        li a0, -1
    2:

    # Save registers to the stack
    sw t0, 0(sp)
    sw t1, 4(sp)

    # Restore the stack
    mv sp, s0
    # Restore return address
    lw ra, 8(sp)
    ret

.section bss
number_str: .zero 11