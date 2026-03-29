#include <plic.h>


#define NUM_SOURCES 31

#define PLIC_BASE 0x30000000

#define PLIC_PRIORITY       0x0
#define PLIC_PENDING        0x1000
#define PLIC_ENABLE         0x2000
#define PLIC_ENABLE_STRIDE  0x80
#define PLIC_CONTEXT        0x200000
#define PLIC_CONTEXT_STRIDE 0x1000


static uint32_t HART_ID;

void plic_init()
{
  __asm__ ("csrr %0, mhartid" : "=r" (HART_ID));

  // init M-mode and S-mode priority thresholds to 0
  *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + (HART_ID * PLIC_CONTEXT_STRIDE)) = 0;
  *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + ((HART_ID+1) * PLIC_CONTEXT_STRIDE)) = 0;

  // init M-mode and S-mode interrupts to disabled
  for (uint32_t i = 0; i <= NUM_SOURCES/32; i++)
  {
    *(volatile uint32_t*)(PLIC_BASE + PLIC_ENABLE + (HART_ID * PLIC_ENABLE_STRIDE) + i*4) = 0;
    *(volatile uint32_t*)(PLIC_BASE + PLIC_ENABLE + ((HART_ID+1) * PLIC_ENABLE_STRIDE) + i*4) = 0;
  }

  if (HART_ID == 0)
  {
    for (uint32_t i = 1; i <= NUM_SOURCES; i++)
    {
      *(volatile uint32_t*)(PLIC_BASE + PLIC_PRIORITY + (i*4)) = 0;
    }
  }
}

void plic_set_priority(uint32_t source, uint32_t priority)
{
  *(volatile uint32_t*)(PLIC_BASE + PLIC_PRIORITY + source*4) = priority;
}

uint32_t plic_get_priority(uint32_t source)
{
  return *(volatile uint32_t*)(PLIC_BASE + PLIC_PRIORITY + source*4);
}

void plic_set_ie(uint32_t source, bool enabled)
{
  // TODO S-mode
  uint32_t swidx = source / 32;
  uint32_t sbidx = source % 32;
  volatile uint32_t* psw = (volatile uint32_t*)(PLIC_BASE + PLIC_ENABLE + HART_ID * PLIC_ENABLE_STRIDE + swidx*4);
  uint32_t enablewi = *psw;
  uint32_t mask = 1 << sbidx;
  uint32_t enablewo = enabled ? (enablewi | mask) : (enablewi & ~mask);
  *psw = enablewo;
}

bool plic_get_ie(uint32_t source)
{
  // TODO S-mode
  uint32_t swidx = source / 32;
  uint32_t sbidx = source % 32;
  uint32_t enablew = *(volatile uint32_t*)(PLIC_BASE + PLIC_ENABLE + HART_ID * PLIC_ENABLE_STRIDE + swidx*4);
  return (bool)((enablew >> sbidx) & 1);
}

void plic_set_threshold(uint32_t priority)
{
  // TODO S-mode
  *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + HART_ID * PLIC_CONTEXT_STRIDE) = priority;
}

uint32_t plic_get_threshold()
{
  // TODO S-mode
  return *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + HART_ID * PLIC_CONTEXT_STRIDE);
}

uint32_t plic_claim()
{
  // TODO S-mode
  return *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + HART_ID * PLIC_CONTEXT_STRIDE + 4);
}

void plic_complete(uint32_t source)
{
  // TODO S-mode
  *(volatile uint32_t*)(PLIC_BASE + PLIC_CONTEXT + HART_ID * PLIC_CONTEXT_STRIDE + 4) = source;
}
