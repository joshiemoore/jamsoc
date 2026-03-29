#include <firmware.h>
#include <uart.h>
#include <timer.h>

#define ADDR_UART 0x10001000

#define UART_REG_RXBUF    0
#define UART_REG_THR      0
#define UART_REG_DIV_LO   0
#define UART_REG_INT_E    1
#define UART_REG_DIV_HI   1
#define UART_REG_INT_ID   2
#define UART_REG_FIFOCTL  2
#define UART_REG_LINECTL  3
#define UART_REG_MDMCTL   4
#define UART_REG_LINEST   5
#define UART_REG_MDMST    6

#define UART_RXBUF   (*(volatile uint8_t*)(ADDR_UART + UART_REG_RXBUF))
#define UART_THR     (*(volatile uint8_t*)(ADDR_UART + UART_REG_THR))
#define UART_DIV_LO  (*(volatile uint8_t*)(ADDR_UART + UART_REG_DIV_LO))
#define UART_INT_E   (*(volatile uint8_t*)(ADDR_UART + UART_REG_INT_E))
#define UART_DIV_HI  (*(volatile uint8_t*)(ADDR_UART + UART_REG_DIV_HI))
#define UART_INT_ID  (*(volatile uint8_t*)(ADDR_UART + UART_REG_INT_ID))
#define UART_FIFOCTL (*(volatile uint8_t*)(ADDR_UART + UART_REG_FIFOCTL))
#define UART_LINECTL (*(volatile uint8_t*)(ADDR_UART + UART_REG_LINECTL))
#define UART_MDMCTL  (*(volatile uint8_t*)(ADDR_UART + UART_REG_MDMCTL))
#define UART_LINEST  (*(volatile uint8_t*)(ADDR_UART + UART_REG_LINEST))
#define UART_MDMST   (*(volatile uint8_t*)(ADDR_UART + UART_REG_MDMST))

#define UART_LINEST_DR      0x01
#define UART_LINEST_OE      0x02
#define UART_LINEST_PE      0x04
#define UART_LINEST_FE      0x08
#define UART_LINEST_BI      0x10
#define UART_LINEST_TXHRE   0x20
#define UART_LINEST_TXEMT   0x40
#define UART_LINEST_ERR     0x80


void uart_set_baud(uint32_t baud)
{
  uint32_t divisor = CLOCK_HZ / (baud * 16);
  UART_LINECTL = 0x80;
  UART_DIV_HI = (uint8_t)(divisor >> 8);
  __asm__ volatile ("fence o, o" ::: "memory");
  UART_DIV_LO = (uint8_t)(divisor & 0xFF);
  UART_LINECTL = 0x03;
  // 1-byte interrupt trigger mode, reset TX/RX FIFOs
  UART_FIFOCTL = 0x06;
}

void uart_tx(char c)
{
  while (!(UART_LINEST & UART_LINEST_TXHRE));
  UART_THR = (uint8_t)c;
}

char uart_rx(void)
{
  while (!(UART_LINEST & UART_LINEST_DR));
  return (char)UART_RXBUF;
}

void uart_set_interrupts(uint8_t flags)
{
  UART_INT_E = flags;
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
