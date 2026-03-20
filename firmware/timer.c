#include "timer.h"


extern uint32_t rdtime_us();
extern uint32_t rdtime_ush();

uint64_t time_us()
{
  uint32_t time_hi = rdtime_ush();
  uint32_t time_lo = rdtime_us();
  return ((uint64_t)time_hi << 32) | time_lo;
}

void delay_us(uint64_t us)
{
  uint64_t start = time_us();
  while (time_us() - start < us);
}
