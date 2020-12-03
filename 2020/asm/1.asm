.global main

times:
    .string " * "
equals:
    .string " = "

main:
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
    call print

    lla a0, input
    call parse_uint
    lla a1, number_str
    call format_uint
    lla a0, number_str
    call println
    li a0, 0
    call exit

iter_input:
    parse_uint


.section bss
number_str: .zero 11