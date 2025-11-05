# A Forth-like intended for experimenting with CH32V003
#
# The CH32V003 has 2KiB of RAM and 16KiB of Flash.
# To save on memory, a simple byte-code stack machine is implemented
# using a lookup table.
# Performance is not a goal. If performance is required, machine code
# can be directly written to a memory location.

.globl _start

.equ R32_RCC_APB2PCENR, 0x40021018
.equ R32_RCC_APB2PCENR.IOPAEN, 1 << 2
.equ R32_RCC_APB2PCENR.IOPCEN, 1 << 4
.equ R32_RCC_APB2PCENR.IOPDEN, 1 << 5

.equ R32_GPIO.cfglr, 0x00
.equ R32_GPIO.indr , 0x08
.equ R32_GPIO.outdr, 0x0C
.equ R32_GPIO.bshr , 0x10
.equ R32_GPIO.bcr  , 0x14
.equ R32_GPIO.lckr , 0x18
.equ R32_GPIO.sizeof, 0x400

.equ R32_GPIOD      , 0x40011400
.equ R32_GPIOD_CFGLR, 0x40011400
.equ R32_GPIOD_INDR , 0x40011408
.equ R32_GPIOD_OUTDR, 0x4001140C
.equ R32_GPIOD_BSHR , 0x40011410
.equ R32_GPIOD_BCR  , 0x40011414
.equ R32_GPIOD_LCKR , 0x40011418

.section .bss
flags:
	.byte 0
	.equ FLAG_COMPILE_MODE

dictionary:

dictionary_end:

.section .init
_start:
	# enable peripherals
	li t0, R32_RCC_APB2PCENR
	lw t1, 0(t0)
	ori t1, t1, R32_RCC_APB2PCENR.IOPDEN
	sw t1, 0(t0)

	# set PD4 to push-pull output mode
	li t0, R32_GPIOD
	lw t1, R32_GPIO.cfglr(t0)
	li t2, ~(0xf << 16)
	and t1, t1, t2
	li t2, 0x3 << 16
	or t1, t1, t2
	sw t1, R32_GPIO.cfglr(t0)
blink_loop:
	# pull PD4 low
	li t1, 1 << 20
	sw t1, R32_GPIO.bshr(t0)
	call delay
	# pull PD4 high
	li t1, 1 << 4
	sw t1, R32_GPIO.bshr(t0)
	call delay
	j blink_loop

delay:
	# fuck this
	li t1, (48 * 1000 * 10) / 2
.Ldelay.loop:
	addi t1, t1, -1
	bnez t1, .Ldelay.loop
	ret

	# There's no mcycle CSR, what the fuck?
delay_FUCK:
	# clock should be set to 48MHz
	# hence, to wait 500ms, wait for 24M cyles
	csrr t2, mcycle
	li t1, (48 * 1000 * 1000) / 2
	#li t1, (48 * 1000) / 2
	add t2, t2, t1
.Ldelay_FUCK.loop:
	csrr t1, mcycle
	sub t1, t1, t2
	bltz t1, .Ldelay.loop
	ret

.section .text
main:
	
