.section .text.start
.global _start

_start:
  li sp, 0x1ff0
  call main
