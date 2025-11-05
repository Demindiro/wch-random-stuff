#!/bin/sh
name=stepper
target=riscv32-none-elf
AS_OPTS=-march=rv32eczicsr
LD_OPTS=
set -xe
$target-as $AS_OPTS main.s -o main.o
$target-ld $LD_OPTS main.o -T link.ld -o $name.elf
