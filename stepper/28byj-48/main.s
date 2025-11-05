.globl _start

.include "../privileged.s"
.include "../ch32v003.s"


.section .init
.option push
.option norvc
intr_vector:
	j _start  # 0
2:	j 2b      # 1
2:	j 2b      # 2
2:	j 2b      # 3
2:	j 2b      # 4
2:	j 2b      # 5
2:	j 2b      # 6
2:	j 2b      # 7
2:	j 2b      # 8
2:	j 2b      # 9
2:	j 2b      # 10
2:	j 2b      # 11
2:	j 2b      # 12
2:	j 2b      # 13
2:	j 2b      # 14
2:	j 2b      # 15
2:	j 2b      # 16
2:	j 2b      # 17
2:	j 2b      # 18
2:	j 2b      # 19
2:	j 2b      # 20
2:	j 2b      # 21
2:	j 2b      # 22
2:	j 2b      # 23
2:	j 2b      # 24
2:	j 2b      # 25
2:	j 2b      # 26
2:	j 2b      # 27
2:	j 2b      # 28
2:	j 2b      # 29
3:	j 3b      # 30
3:	j 3b      # 31
3:	j 3b      # 32
3:	j 3b      # 33
3:	j 3b      # 34
3:	j 3b      # 35
3:	j 3b      # 36
3:	j 3b      # 37
3:	j 3b      # 38
.option pop

.equ MAX_SPEED, 
.equ MAX_ACCEL,

.equ ACCEL_TICKS,


_start:
	# disable interrupts
	csrw mstatus, zero

	# enable peripherals
	li t0, RCC
	lw t1, RCC.apb2pcenr(t0)
	ori t1, t1, RCC.APBxPCENR.IOPCEN
	sw t1, RCC.apb2pcenr(t0)

	# set PC1 to PC4 to push-pull output mode
	li t0, GPIO
	li t1, GPIO.CFGLR.MODE_OUTPUT_2M * 0x11111111
	sw t1, GPIO.C.cfglr(t0)


	li s0, 4000

	li a0, 0
	la a1, round_and_round.halfstep
	li a2, 2048 * 2 * 3
	#la a1, round_and_round.fullstep.alt
	#li a2, 2048
2:
	add t1, a0, a1
	lb t1, 0(t1)
	sw t1, GPIO.C.outdr(t0)
	addi a0, a0, 1

	mv t1, s0
	andi a0, a0, 8 - 1
	#andi a0, a0, 4 - 1

3:	addi t1, t1, -1
	bnez t1, 3b


	addi s0, s0, -10
	li t1, 900
	bgt s0, t1, 3f
	mv s0, t1
3:

	addi a2, a2, -1
	bnez a2, 2b

	
	sw zero, GPIO.C.outdr(t0)
3:	wfi
	j 3b


.section .rodata
round_and_round.halfstep:
	.byte 0b00010
	.byte 0b00110
	.byte 0b00100
	.byte 0b01100
	.byte 0b01000
	.byte 0b11000
	.byte 0b10000
	.byte 0b10010

round_and_round.fullstep:
	.byte 0b00010
	.byte 0b00100
	.byte 0b01000
	.byte 0b10000

round_and_round.fullstep.alt:
	.byte 0b00110
	.byte 0b01100
	.byte 0b11000
	.byte 0b10010
