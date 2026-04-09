  .section .text.start
  .global _start

  .global uart_set_baud

  .global handle_exception
  .global handle_interrupt

_start:
  li sp, 0x8ffffff0

  la t0, trap
  ori t0, t0, 1
  csrw mtvec, t0

  li a0, 115200
  call uart_set_baud

  call plic_init

  /* enable global machine interrupts */
  csrsi mstatus, 0x08
  /* enable mtimer, mswi, and mext interrupts */
  li t0, 0x0888
  csrs mie, t0

  call main
hang:
  j hang

  .align 6
trap:
  addi sp, sp, -32
  sw a0, 0(sp)
  sw a1, 4(sp)
  sw a2, 8(sp)
  sw ra, 12(sp)
  sw t0, 16(sp)

  csrr a0, mepc
  csrr a1, mcause
  csrr a2, mtval
  bltz a1, interrupt
exception:
  jal handle_exception
  j hang
interrupt:
  li t0, 0x7FFFFFFF
  and a1, a1, t0
  jal handle_interrupt

  lw a0, 0(sp)
  lw a1, 4(sp)
  lw a2, 8(sp)
  lw ra, 12(sp)
  lw t0, 16(sp)
  addi sp, sp, 32
  mret
