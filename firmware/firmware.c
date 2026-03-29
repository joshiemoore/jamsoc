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

  uart_print("ready\r\n");
  while (1)
  {
  }
}
