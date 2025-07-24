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
	j systick  # 12
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
2:	j 2b      # 30
2:	j 2b      # 31
2:	j 2b      # 32
2:	j 2b      # 33
2:	j 2b      # 34
2:	j 2b      # 35
2:	j 2b      # 36
2:	j 2b      # 37
2:	j 2b      # 38
.option pop

systick:
	li t0, GPIO
	lw t1, GPIO.D.outdr(t0)
	xori t1, t1, 1 << 4
	sw t1, GPIO.D.outdr(t0)
	li t0, STK
	sw zero, STK.sr(t0)
	mret

_start:
	# this doesn't work, but initial pc is 0 anyway, so...
	#li t1, intr_vector | mtvec.VECTORED
	li t1, mtvec.VECTORED
	csrw mtvec, t1

	li t1, mstatus.MIE
	csrw mstatus, t1

	# enable peripherals
	li t0, RCC
	lw t1, RCC.apb2pcenr(t0)
	ori t1, t1, RCC.APBxPCENR.IOPDEN
	sw t1, RCC.apb2pcenr(t0)

	# set PD4 to push-pull output mode
	li t0, GPIO
	lw t1, GPIO.D.cfglr(t0)
	li t2, ~(0xf << (GPIO.CFGLR.shift * 4))
	and t1, t1, t2
	li t2, GPIO.CFGLR.MODE_OUTPUT_2M << (GPIO.CFGLR.shift * 4)
	or t1, t1, t2
	sw t1, GPIO.D.cfglr(t0)

	# configure SysTick
	li t0, STK
	sw zero, STK.cntl(t0)
	li t1, 1000 * 1000
	sw t1, STK.cmplr(t0)
	li t1, STK.CTLR.STE | STK.CTLR.STRE | STK.CTLR.STIE
	sw t1, STK.ctlr(t0)

	# configure interrupts
	li t0, PFIC
	li t1, 1 << 12
	sw t1, PFIC.ienr1(t0)

2:	wfi
	j 2b
