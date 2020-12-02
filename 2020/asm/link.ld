ENTRY(entry)

MEMORY
{
    ROM (rx) : ORIGIN = 0x8000000, LENGTH = 512M
    RAM (rwx) : ORIGIN = 0x0, LENGTH = 128M
}

SECTIONS
{
    .bss : {
        * (.bss*);
    } > RAM
    .text : {
        * (.text.entry);
        * (.text*);
    } > ROM
    .rodata : {
        * (.rodata*);
    } > ROM
}

stdin = 0xFFFFFFFC;
stdout = 0xFFFFFFFD;
stderr = 0xFFFFFFFE;
SYSTEM_CONTROL = 0xFFFFFFFF;