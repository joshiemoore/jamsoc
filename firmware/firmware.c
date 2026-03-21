#include <stdint.h>

#include <i2c.h>
#include <gpio.h>
#include <uart.h>
#include <timer.h>
#include <lcd.h>


int main()
{
  gpio_set_directions(0xFFFFFFFF);
  uart_set_baud(115200);
  i2c_enable(50000);
  lcd_init(0x27);
  lcd_print(0x27, "Hello, world");
  lcd_set_cursor(0x27, 1, 0);
  const char* HEX = "0123456789ABCDEF";
  char tstring[17];
  tstring[16] = 0;
  while (1)
  {
    gpio_write(0xFFFFFFFF);
    delay_us(500000);
    gpio_write(0x00000000);
    delay_us(499980);
    uint64_t time = time_us();
    uart_print_hex_word(time >> 32);
    uart_print_hex_word(time);
    uart_print("\r\n");
    uint32_t time_hi = time >> 32;
    for (int i = 7; i >= 0; i--)
    {
      tstring[7 - i] = HEX[(time_hi >> (i * 4)) & 0xF];
    }
    uint32_t time_lo = (uint32_t)time;
    for (int i = 7; i >= 0; i--)
    {
      tstring[15 - i] = HEX[(time_lo >> (i * 4)) & 0xF];
    }
    lcd_print(0x27, tstring);
    lcd_set_cursor(0x27, 1, 0);
  }
}
