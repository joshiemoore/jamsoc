MEMORY
{
  mem (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00080000
}

ENTRY(_start)

SECTIONS
{
  . = 0x00000000;

  .text : {
    *(.text.start)
    *(.text*)
  } > mem

  .rodata : {
    *(.rodata*)
  } > mem

  .data : {
    *(.data*)
  } > mem

  .bss : {
    *(.bss*)
    *(COMMON)
  } > mem
}
