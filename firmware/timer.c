#include "timer.h"

#define TIMER_US (*(volatile uint32_t*)0x10003000)


uint32_t time_us()
{
  return TIMER_US;
}

void delay_us(uint32_t us)
{
  uint32_t start = TIMER_US;
  while (TIMER_US - start < us);
}
