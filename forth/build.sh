#!/bin/sh
set -xe
target=iscv32-none-elf
name=forth
$target-as $name.s -o $name.o
$target-ld $name.o -T $name.ld -o $name.elf
