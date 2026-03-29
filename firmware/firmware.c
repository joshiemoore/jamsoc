#include <stdbool.h>
#include <stdint.h>

#include <uart.h>
#include <timer.h>
#include <plic.h>


int main()
{
  plic_set_priority(PLIC_SOURCE_UART, 1);
  plic_set_ie(PLIC_SOURCE_UART, true);

  volatile uint32_t* msip = (volatile uint32_t*)0x21000000;
  volatile uint64_t* mtimer = (volatile uint64_t*)0x20000000;
  volatile uint64_t* mtimecmp = (volatile uint64_t*)0x20000008;
  *mtimecmp = *mtimer + 200000000;
  while (1)
  {
    uart_print_hex_word(*mtimer);
    uart_print("\r\n  ");
    uart_print_hex_word(*mtimecmp);
    uart_print("\r\n");
    delay_us(1000000);
    *msip = 1;
  }
}
