#include <stdint.h>
#include <stdbool.h>


#define PLIC_SOURCE_UART 1

void plic_init();

void plic_set_priority(uint32_t source, uint32_t priority);

uint32_t plic_get_priority(uint32_t source);

void plic_set_ie(uint32_t source, bool enabled);

bool plic_get_ie(uint32_t source);

void plic_set_threshold(uint32_t priority);

uint32_t plic_get_threshold();

uint32_t plic_claim();

void plic_complete(uint32_t source);
