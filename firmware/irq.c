#include <uart.h>


void handler_exception(uint32_t mepc, uint32_t mcause, uint32_t mtval)
{
  uart_print("\r\n\r\nEXCEPTION @ 0x");
  uart_print_hex_word(mepc);
  uart_print("\r\n  mcause: 0x");
  uart_print_hex_word(mcause);
  uart_print("\r\n  mtval:  0x");
  uart_print_hex_word(mtval);
}

