.globl _start

.equ SET_48MHZ, 1
.equ ADJUST_PERIOD, 0

.include "../privileged.s"
.include "../ch32v003.s"

.if SET_48MHZ & ADJUST_PERIOD
 .equ PERIOD, 4899
.else
 .equ PERIOD, 2000
.endif

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
	# this doesn't work, but initial pc is 0 anyway, so...
	#li t1, intr_vector | mtvec.VECTORED
	li t1, mtvec.VECTORED
	csrw mtvec, t1

	li t1, mstatus.MIE
	csrw mstatus, t1

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
	li t1, TIM2.DMAINTENR.UIE
	sh t1, TIM2.dmaintenr(t0)
	li t1, PERIOD
	sh t1, TIM2.atrlr(t0)
	sw zero, TIM2.ch1cvr(t0)
	li t1, (TIM2.OCxM.PWM_1 | TIM2.OCxPE | TIM2.CCxS.OUTPUT) << (8 * 0)
	sh t1, TIM2.chctlr1(t0)
	li t1, TIM2.SWEVGR.UG
	sh t1, TIM2.swevgr(t0)
	li t1, TIM2.CCER.CCxE << (TIM2.CCER.shift * 0)
	sh t1, TIM2.ccer(t0)
	li t1, TIM2.CTLR1.ARPE | TIM2.CTLR1.URS | TIM2.CTLR1.CEN
	sh t1, TIM2.ctlr1(t0)

	# configure SysTick
	li t0, STK
	sw zero, STK.cntl(t0)
	li t1, 1000 * 1000 / 1000
	sw t1, STK.cmplr(t0)
	li t1, STK.CTLR.STE | STK.CTLR.STRE | STK.CTLR.STIE
	sw t1, STK.ctlr(t0)

	# configure interrupts
	li t0, PFIC
	li t1, 1 << (38 - 32)
	sw t1, PFIC.ienr2(t0)

	li t1, 0
	li t2, 1

2:	wfi
	j 2b


tim2upd:
	add t1, t1, t2
	bne t1, zero, 7f
	li t2, 1
7:	li t0, PERIOD
	bne t1, t0, 7f
	li t2, -1
7:	li t0, TIM2
	sw t1, TIM2.ch1cvr(t0)
	li a0, ~TIM2.INTFR.UIF
	sw a0, TIM2.intfr(t0)

	mret
