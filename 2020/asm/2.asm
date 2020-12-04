.global main

main:
    addi sp, sp, -20
    # Stack
    # 0: Number of input bytes left
    # 4: Pointer to current input
    # 8: min for line
    # 12: max for line
    # 16: character to validate for line

    # The number of valid passwords
    li s0, 0

    lw t0, input
    sw t0, 0(sp)
    lla t0, input
    addi t0, t0, 4
    sw t0, 4(sp)

    0:
        # Get the first number
        lw a0, 4(sp)
        li a1, '-'
        call parse_uint
        sb a0, 8(sp)
        addi a1, a1, 1 # walk past the `-`
        call walk_input

        # Get the next number
        lw a0, 4(sp)
        li a1, ' '
        call parse_uint
        sb a0, 12(sp)
        addi a1, a1, 4 # Walk past the ` c: `
        call walk_input

        lw t3, 0(sp)
        lw t4, 4(sp)
        lb t1, -3(t4) # Already walked past the letter, look back a bit 

        # Store the number of matching characters
        li t0, 0
        li t5, '\n'
        10:
            # Get the next character of password
            lb t2, 0(t4)
            # If character matches, increment counter
            bne t2, t1, 11f
                addi t0, t0, 1
            11:
            addi t3, t3, -1
            addi t4, t4, 1
            # If the character is `\n`, string has ended
            beq t2, t5, 1f
            j 10b
    1:
        # Update the input pointer and length
        sw t3, 0(sp)
        sw t4, 4(sp)

        # Check if number of chars is in range
        lw t1, 8(sp)
        lw t2, 12(sp)
        blt t0, t1, 2f
        bgt t0, t2, 2f
        # Increment valid counter
        addi s0, s0, 1
        
    2:
        # Branch if input is all read
        beqz t3, 3f
        j 0b
    3:

    mv a0, s0
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call print
    lla a0, valid_text
    call println

    li a0, 0
    call exit

    walk_input:
        lw t0, 0(sp)
        lw t1, 4(sp)
        sub t0, t0, a1
        add t1, t1, a1
        sw t0, 0(sp)
        sw t1, 4(sp)
        ret

.section .rodata
valid_text:
    .string " valid passwords."

.section bss
number_str:
    .zero 11