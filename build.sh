#!/usr/bin/env bash

ARCH="rv32im"
ABI="ilp32"

CFLAGS="-Os -march=$ARCH -mabi=$ABI -Ifirmware/include/ -nostdlib -ffreestanding -ffunction-sections -fdata-sections -Wl,--gc-sections"
ASMFLAGS="-march=$ARCH -mabi=$ABI"

BUILD_DIR="firmware/build"

set -e
set -x

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

./scripts/gen_bus/gen_bus.py jamsoc.yaml > rtl/jamsoc.v

# TODO firmware makefile
riscv32-unknown-elf-as $ASMFLAGS firmware/start.s -o $BUILD_DIR/start.o
riscv32-unknown-elf-as $ASMFLAGS firmware/timer.s -o $BUILD_DIR/timer_s.o

riscv32-unknown-elf-gcc -c $CFLAGS firmware/firmware.c -o $BUILD_DIR/firmware.o
riscv32-unknown-elf-gcc -c $CFLAGS firmware/uart.c -o $BUILD_DIR/uart.o
riscv32-unknown-elf-gcc -c $CFLAGS firmware/i2c.c -o $BUILD_DIR/i2c.o
riscv32-unknown-elf-gcc -c $CFLAGS firmware/timer.c -o $BUILD_DIR/timer.o
riscv32-unknown-elf-gcc -c $CFLAGS firmware/lcd.c -o $BUILD_DIR/lcd.o
riscv32-unknown-elf-gcc -c $CFLAGS firmware/gpio.c -o $BUILD_DIR/gpio.o

riscv32-unknown-elf-gcc $CFLAGS -T firmware/firmware.ld $BUILD_DIR/*.o -o $BUILD_DIR/firmware.elf

riscv32-unknown-elf-objcopy -O binary $BUILD_DIR/firmware.elf $BUILD_DIR/firmware.bin

#truncate -s 8192 firmware/firmware.bin
hexdump -v -e '"%08x\n"' $BUILD_DIR/firmware.bin > firmware.hex
./scripts/bin_to_mif.py $BUILD_DIR/firmware.bin > firmware.mif
