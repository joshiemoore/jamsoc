#include <i2c.h>
#include <oc_i2c_master.h>
#include <firmware.h>


#define ADDR_I2C 0x10002000

// OC I2C command/control registers
#define I2C_PRER_LO (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_PRER_LO))
#define I2C_PRER_HI (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_PRER_HI))
#define I2C_CTR     (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_CTR))
#define I2C_CR      (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_CR))
#define I2C_SR      (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_SR))

// OC I2C data registers
#define I2C_TXR (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_TXR))
#define I2C_RXR (*(volatile uint8_t*)(ADDR_I2C + OC_I2C_RXR))


void i2c_enable(uint32_t freq)
{
  i2c_wait_transfer();
  I2C_CTR = 0x00;
  uint32_t prescale = CLOCK_HZ / (5 * freq) - 1;
  I2C_PRER_LO = prescale & 0xFF;
  I2C_PRER_HI = (prescale >> 8) & 0xFF;
  I2C_CTR = OC_I2C_EN;
}

void i2c_disable()
{
  I2C_CTR = 0x00;
  I2C_PRER_LO = 0xFF;
  I2C_PRER_HI = 0xFF;
}

bool i2c_start(uint8_t addr_rw)
{
  I2C_TXR = addr_rw;
  I2C_CR = OC_I2C_STA | OC_I2C_WR;
  i2c_wait_transfer();
  return !(bool)(I2C_SR & OC_I2C_RXACK);
}

void i2c_stop()
{
  I2C_CR = OC_I2C_STO | OC_I2C_WR;
  i2c_wait_transfer();
}

bool i2c_write(uint8_t data)
{
  I2C_TXR = data;
  I2C_CR = OC_I2C_WR;
  i2c_wait_transfer();
  return !(bool)(I2C_SR & OC_I2C_RXACK);
}

uint8_t i2c_status()
{
  return I2C_SR;
}

void i2c_wait_busy()
{
  while (I2C_SR & OC_I2C_BUSY);
}

void i2c_wait_transfer()
{
  while (I2C_SR & OC_I2C_TIP);
}
