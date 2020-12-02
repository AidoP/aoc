.global main

times:
    .string " * "
equals:
    .string " = "

main:

    lla a0, times
    call println
    lla a0, input
    call parse_uint
    call printc
    li a0, 0
    call exit

.section bss
number_str: .zero 11