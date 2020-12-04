.global main

main:
    li s0, -1
    li s1, -1

    # allocate persistent stacks for 2 iterators
    addi sp, sp, -32
    mv a0, sp
    call init_iter_input

    0:
        mv a0, sp
        call iter_input

        li t0, -1
        beq a0, t0, 1f
        mv s0, a0

        addi a0, sp, 16
        call init_iter_input
        10:
            addi a0, sp, 16
            call iter_input

            li t0, -1
            beq a0, t0, 0b
            mv s1, a0

            li t0, 2020
            add t1, s0, s1
            beq t0, t1, 2f

            j 10b
    1:
        lla a0, sum_error
        call println
        li a0, 1
        call exit
    2:

    # Calculate the answer
    mul s2, s0, s1
    
    # Print the answer
    mv a0, s0
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call print
    lla a0, times
    call print
    mv a0, s1
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call print
    lla a0, equals
    call print
    mv a0, s2
    lla a1, number_str
    call format_uint
    lla a0, number_str
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
    mv t0, s0
    mv s0, sp
    mv sp, a0
    # Store return address and s0
    sw ra, 8(sp)
    sw t0, 12(sp)
    
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

    # Restore return address and s0
    lw ra, 8(sp)
    mv t0, s0
    lw s0, 12(sp)
    # Restore the stack
    mv sp, t0
    ret

.section .rodata
times:
    .string " * "
equals:
    .string " = "
sum_error:
    .string "Unable to find 2 values that sum to 2020 this dataset"

.section bss
number_str: .zero 11