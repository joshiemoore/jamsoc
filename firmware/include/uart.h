#include <stdint.h>


void uart_set_baud(uint32_t baud);

void uart_tx(char c);

char uart_rx(void);

void uart_print(char* s);

void uart_print_hex_byte(uint8_t b);

void uart_print_hex_word(uint32_t w);

uint32_t uart_getstr(char* s, uint32_t n);
