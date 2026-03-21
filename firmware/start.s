  .section .text.start
  .global _start

  .global uart_set_baud
  .global handler_exception

_start:
  li sp, 0x1ff0

  li a0, 115200
  call uart_set_baud

  la t0, trap
  ori t0, t0, 1
  csrw mtvec, t0

  call main
hang:
  j hang

trap:
  j exception
  .word 0x13371337 /* TODO SSWI */
  .word 0x13371307 /* reserved */
  .word 0x13371337 /* TODO MSWI */

  .word 0x13371319 /* reserved */
  .word 0x13371337 /* TODO STIMER */
  .word 0x13371329 /* reserved */
  .word 0x13371337 /* TODO MTIMER */

  .word 0x13371349 /* reserved */
  .word 0x13371337 /* TODO SEXTI */
  .word 0x13371359 /* reserved */
  .word 0x13371337 /* TODO MEXTI */

  .word 0x13371369 /* reserved */
  .word 0x13371337 /* TODO counter-overflow interrupt */
  .word 0x13371379 /* reserved */
  .word 0x13371389 /* reserved */

exception:
  csrr a0, mepc
  csrr a1, mcause
  csrr a2, mtval
  jal handler_exception
  j hang
