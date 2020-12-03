stdin = 0xFFFFFFFC
stdout = 0xFFFFFFFD
stderr = 0xFFFFFFFE
shutdown = 0xFFFFFFFF
.global input
input = 0x10000000

# Print a character
# a0 - character to print
.global printc
printc:
    li t0, stdout
    sb a0, 0(t0)
    ret

# Print a null delimited string
# a0 - pointer to string
.global print
print:
    li t0, stdout
    0:
        lb t1, 0(a0)
        beqz t1, 1f
        sb t1, 0(t0)
        addi a0, a0, 1
        j 0b
    1:
    ret

# Print a null delimited string followed by a newline
# a0 - pointer to string
.global println
println:
    li t0, stdout
    0:
        lb t1, 0(a0)
        beqz t1, 1f
        sb t1, 0(t0)
        addi a0, a0, 1
        j 0b
    1:
        li t1, 0x0A
        sb t1, 0(t0)
    ret

# Get an unsigned integer from a string
# a0 - string to parse from
# a1 - the terminator
# returns
# a0 - the integer
# a1 - the number of characters parsed
.global parse_uint
parse_uint:
    li t1, '0'
    li t2, '9'
    li t3, 10
    mv t4, a0
    mv t5, t4
    mv t6, a1
    addi a0, zero, 0
    0:
        lb t0, 0(t4)
        beq t0, t6, 3f
        blt t0, t1, 2f
        bgt t0, t2, 2f
        addi t0, t0, -0x30 # subtract '0'
        mul a0, a0, t3
        add a0, a0, t0
        addi t4, t4, 1
        j 0b
    2:
        li a1, 0
        ret
    3:
        sub a1, t4, t5
        ret

# Write an unsigned integer as a string. A 32bit unsigned integer has at most 10 decimal digits
# a0 - The integer to convert to a string
# a1 - a pointer to 11 bytes to output the string to
.global format_uint
format_uint:
    li t0, 1000000000
    li t1, 10 # constant 10
    li t2, 1 # constant 1
    li t5, 0 # true if zeroes should not be ignored
    0:
        # Get digit and remove from number
        div t3, a0, t0
        mul t4, t3, t0
        sub a0, a0, t4

        # If digit is 0 branch, otherwise ensure branch always returns
        beqz t3, 3f
        li t5, 1
    1:
        # Write to then increment string pointer
        addi t3, t3, '0'
        sb t3, 0(a1)
        addi a1, a1, 1
    2:
        # If last digit, return
        beq t0, t2, 4f
        # Divide by 10 for next digit
        div t0, t0, t1
        # loop
        j 0b
    3:
        # If digit is 0 but it is not a leading 0, continue writing to string
        bnez t5, 1b
        # Else, loop to the next digit
        j 2b
    4:
        # Ensure null-terminated
        sb zero, 0(a1)
    ret

# Exit the program
# a0 - exit code
.global exit
exit:
    li t0, shutdown
    sb a0, 0(t0)

.section .text.entry
.global entry
entry:
    li sp, 0x07FFFF8
    call main
    ret