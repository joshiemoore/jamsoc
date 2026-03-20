#include <firmware.h>
#include <uart.h>

#define UART_DATA   (*(volatile uint32_t*)0x10001000)
#define UART_CLKDIV (*(volatile uint32_t*)0x10001004)


void uart_set_baud(uint32_t baud)
{
  UART_CLKDIV = CLOCK_HZ / baud;
}

void uart_tx(char c)
{
  UART_DATA = c;
}

char uart_rx(void)
{
  uint32_t c = 0xFFFFFFFF;
  while (c == 0xFFFFFFFF)
  {
    c = UART_DATA;
  }
  return (char)c;
}

void uart_print(char* s)
{
  while (*s)
  {
    uart_tx(*(s++));
  }
}

void uart_print_hex_byte(uint8_t b)
{
  const char* HEX = "0123456789ABCDEF";
  uart_tx(HEX[(b >> 4) & 0x0F]);
  uart_tx(HEX[b & 0x0F]);
}

void uart_print_hex_word(uint32_t w)
{
  for (int i = 3; i >= 0; i--)
  {
    uart_print_hex_byte((w >> (i * 8)) & 0xFF);
  }
}

uint32_t uart_getstr(char* s, uint32_t n)
{
  if (n == 0) return 0;

  uint32_t nr = 0;
  while (nr < n - 1)
  {
    char c = uart_rx();
    if (c == '\r')
    {
      break;
    }
    uart_tx(c);
    nr++;
    *(s++) = c;
  }
  *s = 0;
  return nr;
}
