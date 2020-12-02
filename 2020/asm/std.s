stdin = 0xFFFFFFFC
stdout = 0xFFFFFFFD
stderr = 0xFFFFFFFE
shutdown = 0xFFFFFFFF
.global input
input = 0x10000001

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
    addi a0, zero, 0
    0:
        lb t0, 0(t4)
        beqz t0, 3f
        ble t0, t1, 2f
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

# Exit the program
# a0 - exit code
.global exit
exit:
    li t0, shutdown
    sb a0, 0(t0)

.section .text.entry
.global entry
entry:
    call main
    ret