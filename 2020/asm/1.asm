.global main

hello_world:
    .string "Hello, World!"

main:
    lla a0, hello_world
    call println
    li a0, 0
    call exit