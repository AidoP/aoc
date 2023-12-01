ENTRY(aoc)

MEMORY
{
    TEXT (rx) : ORIGIN = 0x0000008000000000, LENGTH = 16M
    BSS (rw) : ORIGIN = 0x0000007FFFF00000, LENGTH = 16K
}

SECTIONS
{
    .bss : {
        * (.rt-impl);
    } > BSS
    .bss : {
        * (.bss*);
    } > BSS

    .text : {
        * (.entry);
    } > TEXT
    .text : {
        * (.text*);
    } > TEXT
    .rodata : {
        * (.rodata*);
    } > TEXT
}
