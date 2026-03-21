#!/usr/bin/env bash

CROSS_COMPILE="riscv32-unknown-elf"
ARCH="rv32im_zicsr_zifencei"
ABI="ilp32"

CFLAGS="-Os -Wall -Werror -march=$ARCH -mabi=$ABI -Ifirmware/include/ -nostdlib -ffreestanding -ffunction-sections -fdata-sections -Wl,--gc-sections"
ASMFLAGS="-march=$ARCH -mabi=$ABI"

BUILD_DIR="firmware/build"

set -e
set -x

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

./scripts/gen_bus/gen_bus.py jamsoc.yaml > rtl/jamsoc.v

# TODO firmware makefile
$CROSS_COMPILE-as $ASMFLAGS firmware/start.s -o $BUILD_DIR/start.o
$CROSS_COMPILE-as $ASMFLAGS firmware/timer.s -o $BUILD_DIR/timer_s.o

$CROSS_COMPILE-gcc -c $CFLAGS firmware/firmware.c -o $BUILD_DIR/firmware.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/uart.c -o $BUILD_DIR/uart.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/i2c.c -o $BUILD_DIR/i2c.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/timer.c -o $BUILD_DIR/timer.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/lcd.c -o $BUILD_DIR/lcd.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/gpio.c -o $BUILD_DIR/gpio.o
$CROSS_COMPILE-gcc -c $CFLAGS firmware/irq.c -o $BUILD_DIR/irq.o

$CROSS_COMPILE-gcc $CFLAGS -T firmware/firmware.ld $BUILD_DIR/*.o -o $BUILD_DIR/firmware.elf

$CROSS_COMPILE-objcopy -O binary $BUILD_DIR/firmware.elf $BUILD_DIR/firmware.bin

#truncate -s 8192 firmware/firmware.bin
hexdump -v -e '"%08x\n"' $BUILD_DIR/firmware.bin > firmware.hex
./scripts/bin_to_mif.py $BUILD_DIR/firmware.bin > firmware.mif
