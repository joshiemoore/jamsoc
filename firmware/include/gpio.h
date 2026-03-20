#include <stdint.h>


#define GPIO_DIR_OUTPUT 1
#define GPIO_DIR_INPUT  0

#define GPIO_ALL_OUTPUT 0xFFFFFFFF
#define GPIO_ALL_INPUT  0x00000000


void gpio_write(uint32_t data);

void gpio_write_pin(uint8_t pin, bool value);

uint32_t gpio_get();

bool gpio_get_pin(uint8_t pin);

void gpio_set_directions(uint32_t directions);

void gpio_set_pin_direction(uint8_t pin, bool direction);

uint32_t gpio_get_directions();

bool gpio_get_pin_direction(uint8_t pin);
