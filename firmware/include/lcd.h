//
// I2C LCD2004 driver
//
// https://www.handsontec.com/dataspecs/I2C_2004_LCD.pdf
// https://cdn.sparkfun.com/assets/9/5/f/7/b/HD44780.pdf
// https://www.ti.com/lit/ds/symlink/pcf8574.pdf
//
// TODO
// This was written specifically for the 20x4 handsontec LCD module.
// It could (and should) be made generic to work with other HD44780-based
// displays with differing display sizes and hardware features.
//

#include <stdbool.h>
#include <stdint.h>


// displaymode flags
#define LCD_DISPLAY_ON   0x04
#define LCD_DISPLAY_OFF  0x00
#define LCD_CURSOR_ON    0x02
#define LCD_CURSOR_OFF   0x00
#define LCD_BLINK_ON     0x01
#define LCD_BLINK_OFF    0x00

// entrymode flags
#define LCD_CURSOR_RIGHT 0x02
#define LCD_CURSOR_LEFT  0x00
#define LCD_SHIFT_ON     0x01
#define LCD_SHIFT_OFF    0x00

// function set flags
#define LCD_8BIT         0x10
#define LCD_4BIT         0x00
#define LCD_LINES_2      0x08
#define LCD_LINES_1      0x00
#define LCD_FONT_510     0x04  // 5x10 glyphs
#define LCD_FONT_58      0x00  // 5x8 glyphs


void lcd_init(uint8_t lcd_addr);

void lcd_print(uint8_t lcd_addr, char* s);

void lcd_clear(uint8_t lcd_addr);

void lcd_home(uint8_t lcd_addr);

void lcd_set_displaymode(uint8_t lcd_addr, uint8_t mode);

void lcd_set_entrymode(uint8_t lcd_addr, uint8_t mode);

void lcd_set_function(uint8_t lcd_addr, uint8_t mode);

void lcd_set_cursor(uint8_t lcd_addr, uint8_t row, uint8_t col);
