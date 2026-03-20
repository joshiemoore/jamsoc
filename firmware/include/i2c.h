#include <stdint.h>


void i2c_enable(uint32_t freq);

void i2c_disable();

// addr_rw should have the high 7 bits set to the slave address,
// and the LSB should be the R/W bit.
// returns true if ACK, false if NACK
bool i2c_start(uint8_t addr_rw);

void i2c_stop();

// returns true if ACK, false if NACK
bool i2c_write(uint8_t data);

uint8_t i2c_status();

void i2c_wait_busy();

void i2c_wait_transfer();
