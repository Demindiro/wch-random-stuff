.globl _start

.include "../privileged.s"
.include "../ch32v003.s"

.section .rodata.colors
.p2align 2
colors:
.include "colors.s"
colors.end:

# NOTE: It appears the actual frequency is 24MHz? Probably misconfigured somewhere
.equ SET_48MHZ, 1

.if SET_48MHZ
 .if 1
  # The tolerances on the datasheet appear to be really tight,
  # even tighter than actual limits?
  # bumping up period fixed red channel bits bleeding into blue
  #.equ PERIOD, 40 # MIN: 1.2µs -> 24e6*s^-1 * 1.2e-6*s = 28.8
  #.equ PERIOD, 1000 # MIN: 1.2µs -> 24e6*s^-1 * 1.2e-6*s = 28.8
  .equ PERIOD, 500 # MIN: 1.2µs -> 24e6*s^-1 * 1.2e-6*s = 28.8
  .equ LO_T,  7   # MIN: 0.2µs, TYP: 0.3µs, MAX: 0.4µs -> 24e6*s^-1 * {0.2,0.3,0.4}e-6*s = {4.8,7.2,9.6}
  .equ HI_T, 21   # MIN: 0.65µs, TYP: 0.9µs, MAX: 1µs  -> 24e6*s^-1 * {0.65,0.9,1}e-6*s = {15.6,21.6,24}
 .elseif 1
  .equ PERIOD, 29 # MIN: 1.2µs -> 24e6*s^-1 * 1.2e-6*s = 28.8
  .equ LO_T,  7   # MIN: 0.2µs, TYP: 0.3µs, MAX: 0.4µs -> 24e6*s^-1 * {0.2,0.3,0.4}e-6*s = {4.8,7.2,9.6}
  .equ HI_T, 21   # MIN: 0.65µs, TYP: 0.9µs, MAX: 1µs  -> 24e6*s^-1 * {0.65,0.9,1}e-6*s = {15.6,21.6,24}
 .elseif 1
  .equ PERIOD, 58 # MIN: 1.2µs -> 48e6*s^-1 * 1.2e-6*s = 58
  #.equ PERIOD, 70 # MIN: 1.2µs -> 48e6*s^-1 * 1.2e-6*s = 58
  .equ LO_T, 14   # MIN: 0.2µs, TYP: 0.3µs, MAX: 0.4µs -> 48e6*s^-1 * {0.2,0.3,0.4}e-6*s = {9.6,14.4,19.2}
  .equ HI_T, 43   # MIN: 0.65µs, TYP: 0.9µs, MAX: 1µs  -> 48e6*s^-1 * {0.65,0.9,1}e-6*s = {31.2,43.2,48}
 .else
  .equ PERIOD, 10 * 6
  #.equ LO_T, PERIOD - (2 * 6)
  #.equ HI_T, PERIOD - (7 * 6)
  .equ LO_T, 2 * 6
  .equ HI_T, 7 * 6
 .endif
.elseif 0
 # clock = 8MHz = 8e6 * s^-1
 # period = 1.2µs = 1.2e-6 * s
 # ==> cycles = clock * period = 1.2e-6 * 8e6 = 9.6
 # round to 10
 .equ PERIOD, 10
 # 10 cycles need to be split in at least 3 parts, ideally 4 equal parts
 # 2-3-3-2 (0.25µs-0.375µs-0.375µs-0.25µs) should be close enough
 .equ LO_T, 2 # 2 * 10 / 8 = 0.25µs
 .equ HI_T, 7 # 7 * 10 / 8 = 0.875µs
.elseif 1
 .equ PERIOD, 10 # MIN: 1.2µs -> 8e6*s^-1 * 1.2e-6*s = 9.6
 .equ LO_T, 2   # MIN: 0.2µs, TYP: 0.3µs, MAX: 0.4µs -> 8e6*s^-1 * {0.2,0.3,0.4}e-6*s = {1.6,2.4,3.2}
 .equ HI_T, 7   # MIN: 0.65µs, TYP: 0.9µs, MAX: 1µs  -> 8e6*s^-1 * {0.65,0.9,1}e-6*s = {5.2,7.2,8}
.endif

#.equ RESET_TICKS, 200 # 200µs -> 200µs / 1.2µs = 166.6, but just take 200 to keep it simple
#.equ RESET_TICKS, 809
# I evidently can't do math...
#.equ RESET_TICKS, 809 * 10
#.equ RESET_TICKS, 24 * 1000 * 3 / PERIOD - 24

#.equ RESET_TICKS, 24 * 100000 * 3 / PERIOD - 24
.equ RESET_TICKS, 24 * 2000 * 3 / PERIOD - 24

.equ LED_COUNT, 3
.equ LED_COUNTERS, SRAM

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
	j tim2upd  # 38
.option pop


_start:
	# disable interrupts
	csrw mstatus, zero

	li t0, RCC
	lw t1, RCC.rstsckr(t0)
	li t2, 1 << 24
	sw t2, RCC.rstsckr(t0)
	li t0, SRAM
	sw t1, 4(t0)

	li t0, SRAM
	lw t1, 8(t0)
	addi t1, t1, 1
	sw t1, 8(t0)

	# this doesn't work, but initial pc is 0 anyway, so...
	#li t1, intr_vector | mtvec.VECTORED
	li t1, mtvec.VECTORED
	csrw mtvec, t1

	# initialize SRAM
	li t0, LED_COUNTERS
	la t1, colors
	#li t2, (COLOR_ENTRIES / LED_COUNT) * 4
	sw t1, 8(t0)
	addi t1, t1, 200
	sw t1, 4(t0)
	addi t1, t1, 200
	sw t1, 0(t0)

	# enable peripherals
	li t0, RCC
.if SET_48MHZ
	lw t1, RCC.cfgr0(t0)
	andi t1, t1, ~0xff # HB prescaler off, set SYSCLK to PLL
	ori  t1, t1, 2
	sw t1, RCC.cfgr0(t0)
.endif
	lw t1, RCC.apb2pcenr(t0)
	ori t1, t1, RCC.APBxPCENR.IOPDEN
	sw t1, RCC.apb2pcenr(t0)
	li t1, RCC.APB1PCENR.TIM2EN
	sw t1, RCC.apb1pcenr(t0)

	# set PD4 to multiplexed push-pull output mode
	li t0, GPIO
	lw t1, GPIO.D.cfglr(t0)
	li t2, ~(0xf << (4 * 4))
	and t1, t1, t2
	li t2, (GPIO.CFGLR.MODE_OUTPUT_2M | GPIO.CFGLR.CNF_OUTPUT_MULTIPLEX) << (4 * 4)
	or t1, t1, t2
	sw t1, GPIO.D.cfglr(t0)

	# configure GPTM
	# CH1 is used for driving PD4
	li t0, TIM2
	#li t1, (TIM2.DMAINTENR.TIE | TIM2.DMAINTENR.UIE)
	li t1, TIM2.DMAINTENR.UIE
	sh t1, TIM2.dmaintenr(t0)
	li t1, PERIOD
	sh t1, TIM2.atrlr(t0)
	#sw zero, TIM2.ch1cvr(t0)
	#li t1, -1
	li t1, 0
	sw t1, TIM2.ch1cvr(t0)
	li t1, (TIM2.OCxM.PWM_1 | TIM2.OCxPE | TIM2.CCxS.OUTPUT) << (8 * 0)
	sh t1, TIM2.chctlr1(t0)
	li t1, TIM2.SWEVGR.UG
	sh t1, TIM2.swevgr(t0)
	li t1, TIM2.CCER.CCxE << (TIM2.CCER.shift * 0)
	sh t1, TIM2.ccer(t0)
	li t1, TIM2.CTLR1.ARPE | TIM2.CTLR1.DIR | TIM2.CTLR1.URS | TIM2.CTLR1.CEN
	li t1, TIM2.CTLR1.ARPE | TIM2.CTLR1.URS | TIM2.CTLR1.CEN
	sh t1, TIM2.ctlr1(t0)
	# make sure the interrupt bit is cleared
	li t1, ~TIM2.INTFR.UIF
	sw t1, TIM2.intfr(t0)

	# start with reset (0), then each led (1, 2, ...)
	li a2, 0
	li a5, RESET_TICKS

	la a3, colors
	la a4, colors.end

	# configure interrupts
	li t0, PFIC_TAIL
	li t1, PFIC_TAIL.SCTLR.SLEEPONEXIT
	sw t1, PFIC_TAIL.sctlr(t0)
	li t0, PFIC
	#li t1, 1 << 12
	#sw t1, PFIC.ienr1(t0)
	li t1, 1 << (38 - 32)
	sw t1, PFIC.ienr2(t0)

	li t1, 0
	li t2, 1

	# enable interrupts and wait for all eternity
	li t1, mstatus.MIE
	csrw mstatus, t1

2:	#wfi
	j 2b


tim2upd:
	li t0, TIM2
	li t1, ~TIM2.INTFR.UIF
	sw t1, TIM2.intfr(t0)
	# predecrement counter
	addi a5, a5, -1
	bltz a5, .Ltim2upd_next.led
	# check if we're in reset or LED stage
	beqz a2, .Ltim2upd_reset

.Ltim2upd_led:
	srl t0, a3, a5
	andi t0, t0, 1
	beqz t0, .Ltim2upd_bit_lo
.Ltim2upd_bit_hi:
	li t1, HI_T
	j .Ltim2upd_bit_set
.Ltim2upd_bit_lo:
	li t1, LO_T
.Ltim2upd_bit_set:
	li t0, TIM2
	sw t1, TIM2.ch1cvr(t0)
	mret


.Ltim2upd_next.led:
	li t0, LED_COUNT
	beq a2, t0, .Ltim2upd_next.reset

	slli t1, a2, 2 # *4
	li t0, LED_COUNTERS
	add t0, t0, t1
	lw t1, (t0)
	addi t1, t1, 4
	bne t1, a4, .Ltim2upd_next.led.nowrap
	la t1, colors
.Ltim2upd_next.led.nowrap:
	sw t1, (t0)
	lw a3, (t1)

	addi a2, a2, 1
	li a5, 24 - 1
	j .Ltim2upd_led


.Ltim2upd_next.reset:
	li a2, 0
	li a5, RESET_TICKS - 1
.Ltim2upd_reset:
	li t0, TIM2
	li t1, 0
	sw t1, TIM2.ch1cvr(t0)
	mret
