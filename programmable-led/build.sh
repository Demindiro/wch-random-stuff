#!/bin/sh
name=programmable-led
target=riscv32-none-elf
AS_OPTS=-march=rv32eczicsr
LD_OPTS=
set -xe
$target-as $AS_OPTS $name.s -o $name.o
$target-ld $LD_OPTS $name.o -T $name.ld -o $name.elf
