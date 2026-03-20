#include <gpio.h>


#define GPIO_DATA (*(volatile uint32_t*)0x10000000)
#define GPIO_DIR  (*(volatile uint32_t*)0x10000004)


uint32_t set_bit(uint32_t cur_value, uint8_t bit, uint8_t idx)
{
  uint32_t bit_shifted = (bit & 0x01) << idx;
  uint32_t mask = 1 << idx;
  return (cur_value & ~mask) | (bit_shifted & mask);
}


void gpio_write(uint32_t data)
{
  GPIO_DATA = data;
}

void gpio_write_pin(uint8_t pin, bool value)
{
  GPIO_DATA = set_bit(GPIO_DATA, value, pin);
}

uint32_t gpio_get()
{
  return GPIO_DATA;
}

bool gpio_get_pin(uint8_t pin)
{
  return (bool)((GPIO_DATA >> pin) & 1);
}

void gpio_set_directions(uint32_t directions)
{
  GPIO_DIR = directions;
}

void gpio_set_pin_direction(uint8_t pin, bool direction)
{
  GPIO_DIR = set_bit(GPIO_DIR, direction, pin);
}

uint32_t gpio_get_directions()
{
  return GPIO_DIR;
}

bool gpio_get_pin_direction(uint8_t pin)
{
  return (bool)((GPIO_DIR >> pin) & 1);
}
