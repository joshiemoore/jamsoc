#include <stdbool.h>
#include <stdint.h>

#include <uart.h>
#include <timer.h>
#include <plic.h>


int main()
{
  plic_set_priority(PLIC_SOURCE_UART, 1);
  plic_set_ie(PLIC_SOURCE_UART, true);
  plic_set_priority(PLIC_SOURCE_BTN0, 1);
  plic_set_ie(PLIC_SOURCE_BTN0, true);

  uart_set_interrupts(UART_INT_DR);

  delay_us(500000);

  uart_print("\r\nrunning memory test...");

  volatile uint32_t* tst_mem = (volatile uint32_t*)0x80000000;
  for (uint32_t i = 0; i < 0x40000; i++)
  {
    tst_mem[i] = i ^ 0xAAAAAAAA;
  }
  for (uint32_t i = 0; i < 0x40000; i++)
  {
    uint32_t tmp = tst_mem[i] ^ 0xAAAAAAAA;
    if (tmp != i)
    {
      uart_print("\r\n  fail ");
      uart_print_hex_word(i);
      uart_print(" ");
      uart_print_hex_word(tmp);
      while(1);
    }
  }

  uart_print("\r\nready\r\n");
  while (1)
  {
  }
}
