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
  while (1)
  {
    gpio_write(0xFFFFFFFF);
    uart_tx('A');
    delay_us(1000000);
    gpio_write(0x00000000);
    uart_tx('B');
    delay_us(1000000);
  }
}
