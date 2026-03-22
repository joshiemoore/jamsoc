#include <uart.h>


#define INT_SSWI 1
#define INT_MSWI 3
#define INT_STIMER 5
#define INT_MTIMER 7
#define INT_SEXTI 9
#define INT_MEXTI 11
#define INT_CNTRF 13

void handle_exception(uint32_t mepc, uint32_t mcause, uint32_t mtval)
{
  uart_print("\r\n\r\nEXCEPTION @ 0x");
  uart_print_hex_word(mepc);
  uart_print("\r\n  mcause: 0x");
  uart_print_hex_word(mcause);
  uart_print("\r\n  mtval:  0x");
  uart_print_hex_word(mtval);
}

void handle_interrupt(uint32_t mepc, uint32_t mcause, uint32_t mtval)
{
  switch (mcause)
  {
    case INT_SSWI:
      // TODO
      break;
    case INT_MSWI:
      // TODO
      break;
    case INT_STIMER:
      // TODO
      break;
    case INT_MTIMER:
      // TODO
      uart_print("\r\ntimer!\r\n");
      // TODO reset timer based on hart ID
      //volatile uint64_t* mtimer = (volatile uint64_t*)0x20000000;
      volatile uint64_t* mtimecmp = (volatile uint64_t*)0x20000008;
      *mtimecmp = *mtimecmp + 100000000;
      break;
    case INT_SEXTI:
      // TODO
      break;
    case INT_MEXTI:
      // TODO
      break;
    case INT_CNTRF:
      // TODO
      break;
    default:
      uart_print("unhandled interrupt exception\r\n");
      handle_exception(mepc, mcause, mtval);
      break;
  }
}
