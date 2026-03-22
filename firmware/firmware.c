#include <stdint.h>

#include <i2c.h>
#include <gpio.h>
#include <uart.h>
#include <timer.h>
#include <lcd.h>


int main()
{
  volatile uint64_t* mtimer = (volatile uint64_t*)0x20000000;
  volatile uint64_t* mtimecmp = (volatile uint64_t*)0x20000008;
  *mtimecmp = *mtimer + 100000000;
  while (1)
  {
    uart_print_hex_word(*mtimer);
    uart_print("\r\n  ");
    uart_print_hex_word(*mtimecmp);
    uart_print("\r\n");
    delay_us(1000000);
  }
}
