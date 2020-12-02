stdin = 0xFFFFFFFC
stdout = 0xFFFFFFFD
stderr = 0xFFFFFFFE
shutdown = 0xFFFFFFFF

# Print a character
# a0 - character to print
.global printc
printc:
    li t0, stdout
    sb a0, 0(t0)
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

# Exit the program
# a0 - exit code
.global exit
exit:
    li t0, shutdown
    sb a0, 0(t0)

.section .text.entry
.global entry
entry:
    lla a0, run
    call println
    call main
    ret

run:
    .string "Running!"