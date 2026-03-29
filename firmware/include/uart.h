// basic UART 16550 driver for testing

#include <stdint.h>


#define UART_INT_NONE 0x00
#define UART_INT_DR   0x01
#define UART_INT_THRE 0x02
#define UART_INT_RLST 0x04
#define UART_INT_MDST 0x08

void uart_set_baud(uint32_t baud);

void uart_tx(char c);

char uart_rx(void);

void uart_set_interrupts(uint8_t flags);

void uart_print(char* s);

void uart_print_hex_byte(uint8_t b);

void uart_print_hex_word(uint32_t w);

uint32_t uart_getstr(char* s, uint32_t n);
