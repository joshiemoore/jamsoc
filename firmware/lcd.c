#include <i2c.h>
#include <lcd.h>
#include <timer.h>

#define LCD_ROWS 4
#define LCD_COLS 20

// signals
#define LCD_BACKLIGHT 0x08
#define LCD_E         0x04
#define LCD_RW        0x02
#define LCD_RS        0x01

// instructions
#define LCD_INST_CLEAR           0x01
#define LCD_INST_HOME            0x02
#define LCD_INST_SET_ENTRYMODE   0x04
#define LCD_INST_SET_DISPLAYMODE 0x08
#define LCD_INST_SHIFT_CURSOR    0x10
#define LCD_INST_SET_FUNCTION    0x20
#define LCD_INST_SET_CGRAM_ADDR  0x40
#define LCD_INST_SET_DDRAM_ADDR  0x80


void lcd_i2c_write(uint8_t lcd_addr, uint8_t data)
{
  i2c_start(lcd_addr << 1);
  i2c_write(data);
  i2c_stop();
}

void lcd_pulse(uint8_t lcd_addr, uint8_t data)
{
  lcd_i2c_write(lcd_addr, data | LCD_E);
  lcd_i2c_write(lcd_addr, data & ~LCD_E);
}

void lcd_write_nibble(uint8_t lcd_addr, uint8_t nibble, bool rs)
{
  uint8_t data = (nibble << 4) | (rs ? LCD_RS : 0) | LCD_BACKLIGHT;
  lcd_pulse(lcd_addr, data);
}

void lcd_write_byte(uint8_t lcd_addr, uint8_t value, bool rs)
{
  lcd_write_nibble(lcd_addr, value >> 4, rs);
  lcd_write_nibble(lcd_addr, value & 0x0F, rs);
}

void lcd_command(uint8_t lcd_addr, uint8_t cmd)
{
  lcd_write_byte(lcd_addr, cmd, false);
}


void lcd_init(uint8_t lcd_addr)
{
  // initialization sequence
  delay_us(20000);
  lcd_write_nibble(lcd_addr, 0x3, false);
  delay_us(5000);
  lcd_write_nibble(lcd_addr, 0x3, false);
  delay_us(200);
  lcd_write_nibble(lcd_addr, 0x3, false);
  lcd_write_nibble(lcd_addr, 0x2, false);

  lcd_set_function(lcd_addr, LCD_4BIT | LCD_LINES_2 | LCD_FONT_58);
  lcd_set_displaymode(lcd_addr, LCD_DISPLAY_ON | LCD_CURSOR_OFF | LCD_BLINK_OFF);
  lcd_set_entrymode(lcd_addr, LCD_CURSOR_RIGHT | LCD_SHIFT_OFF);
  lcd_clear(lcd_addr);
  lcd_home(lcd_addr);
}

void lcd_print(uint8_t lcd_addr, char* s)
{
  while (*s)
  {
    lcd_write_byte(lcd_addr, *(s++), true);
  }
}

void lcd_clear(uint8_t lcd_addr)
{
  lcd_command(lcd_addr, LCD_INST_CLEAR);
  delay_us(2000);
}

void lcd_home(uint8_t lcd_addr)
{
  lcd_command(lcd_addr, LCD_INST_HOME);
  delay_us(2000);
}

void lcd_set_displaymode(uint8_t lcd_addr, uint8_t mode)
{
  lcd_command(lcd_addr, LCD_INST_SET_DISPLAYMODE | (mode & 0x07));
  delay_us(40);
}

void lcd_set_entrymode(uint8_t lcd_addr, uint8_t mode)
{
  lcd_command(lcd_addr, LCD_INST_SET_ENTRYMODE | (mode & 0x03));
  delay_us(40);
}

void lcd_set_function(uint8_t lcd_addr, uint8_t mode)
{
  lcd_command(lcd_addr, LCD_INST_SET_FUNCTION | (mode & 0x1C));
  delay_us(40);
}

void lcd_set_cursor(uint8_t lcd_addr, uint8_t row, uint8_t col)
{
  uint8_t row_offsets[] = { 0x00, 0x40, 0x14, 0x54 };
  if (row > LCD_ROWS - 1) row = LCD_ROWS - 1;
  if (col > LCD_COLS - 1) col = LCD_COLS - 1;
  lcd_command(lcd_addr, LCD_INST_SET_DDRAM_ADDR | (row_offsets[row] + col));
  delay_us(40);
}
