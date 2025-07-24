.equ SRAM, 0x20000000

.equ TIM2, 0x40000000
.equ TIM2.ctlr1    , 0x00
.equ TIM2.ctlr2    , 0x04
.equ TIM2.smcfgr   , 0x08
.equ TIM2.dmaintenr, 0x0c
.equ TIM2.intfr    , 0x10
.equ TIM2.swevgr   , 0x14
.equ TIM2.chctlr1  , 0x18
.equ TIM2.chctlr2  , 0x1c
.equ TIM2.ccer     , 0x20
.equ TIM2.cnt      , 0x24
.equ TIM2.psc      , 0x28
.equ TIM2.atrlr    , 0x2c
# no ch0cvr?
.equ TIM2.ch1cvr   , 0x34
.equ TIM2.ch2cvr   , 0x38
.equ TIM2.ch3cvr   , 0x3c
.equ TIM2.ch4cvr   , 0x40
.equ TIM2.dmacfgr  , 0x48
.equ TIM2.dmaadr   , 0x4c
.equ TIM2.CTLR1.ARPE, 1 << 7
.equ TIM2.CTLR1.CMS , 3 << 5
.equ TIM2.CTLR1.DIR , 1 << 4
.equ TIM2.CTLR1.OPM , 1 << 3
.equ TIM2.CTLR1.URS , 1 << 2
.equ TIM2.CTLR1.UDIS, 1 << 1
.equ TIM2.CTLR1.CEN , 1 << 0
.equ TIM2.DMAINTENR.TIE  , 1 << 6
.equ TIM2.DMAINTENR.CC4IE, 1 << 4
.equ TIM2.DMAINTENR.CC3IE, 1 << 3
.equ TIM2.DMAINTENR.CC2IE, 1 << 2
.equ TIM2.DMAINTENR.CC1IE, 1 << 1
.equ TIM2.DMAINTENR.UIE  , 1 << 0
.equ TIM2.INTFR.TIF  , 1 << 6
.equ TIM2.INTFR.CC4IF, 1 << 4
.equ TIM2.INTFR.CC3IF, 1 << 3
.equ TIM2.INTFR.CC2IF, 1 << 2
.equ TIM2.INTFR.CC1IF, 1 << 1
.equ TIM2.INTFR.UIF  , 1 << 0
.equ TIM2.SWEVGR.TG  , 1 << 6
.equ TIM2.SWEVGR.CC4G, 1 << 4
.equ TIM2.SWEVGR.CC3G, 1 << 3
.equ TIM2.SWEVGR.CC2G, 1 << 2
.equ TIM2.SWEVGR.CC1G, 1 << 1
.equ TIM2.SWEVGR.UG  , 1 << 0
.equ TIM2.CCER.shift, 4
.equ TIM2.CCER.CCxP,  1 << 1
.equ TIM2.CCER.CCxE,  1 << 0
.equ TIM2.OCxCE, 1 << 7
.equ TIM2.OCxM.FREEZE        , 0 << 4
.equ TIM2.OCxM.FORCE_SET_HIGH, 1 << 4
.equ TIM2.OCxM.FORCE_SET_LOW , 2 << 4
.equ TIM2.OCxM.FLIP          , 3 << 4
.equ TIM2.OCxM.FORCE_HIGH    , 4 << 4
.equ TIM2.OCxM.FORCE_LOW     , 5 << 4
.equ TIM2.OCxM.PWM_1         , 6 << 4
.equ TIM2.OCxM.PWM_2         , 7 << 4
.equ TIM2.OCxPE, 1 << 3
.equ TIM2.OCxFE, 1 << 2
.equ TIM2.CCxS.OUTPUT, 0 << 0
.equ TIM2.CCxS.INPUT_TI2, 1 << 0
.equ TIM2.CCxS.INPUT_TI1, 2 << 0
.equ TIM2.CCxS.INPUT_TRC, 3 << 0

.equ GPIO, 0x40011000
.equ GPIO.A, -0x800
# one can't help but wonder what happened to B(egone?)
.equ GPIO.C, 0x000
.equ GPIO.D, 0x400
.equ GPIO.cfglr, 0x00
.equ GPIO.indr , 0x08
.equ GPIO.outdr, 0x0C
.equ GPIO.bshr , 0x10
.equ GPIO.bcr  , 0x14
.equ GPIO.lckr , 0x18
.macro _r32_gpio_bank_with x:req name:req names:vararg
 .equ GPIO.\x\().\name, GPIO.\x + GPIO.\name
 .ifnb \names
  _r32_gpio_bank_with \x \names
 .endif
.endm
.macro _r32_gpio_bank x:req s:vararg
 _r32_gpio_bank_with \x cfglr indr outdr bshr bcr lckr
 .ifnb \s
  _r32_gpio_bank \s
 .endif
.endm
_r32_gpio_bank A C D
.purgem _r32_gpio_bank
.purgem _r32_gpio_bank_with
.equ GPIO.CFGLR.shift, 4
.equ GPIO.CFGLR.CNF_INPUT_ANALOG, 0 << 2
.equ GPIO.CFGLR.CNF_INPUT_FLOAT , 1 << 2
.equ GPIO.CFGLR.CNF_INPUT_PULL  , 2 << 2
.equ GPIO.CFGLR.CNF_OUTPUT_OPEN_DRAIN, (1 << 0) << 2
.equ GPIO.CFGLR.CNF_OUTPUT_MULTIPLEX , (1 << 1) << 2
.equ GPIO.CFGLR.MODE_INPUT,      0 << 0
.equ GPIO.CFGLR.MODE_OUTPUT_10M, 1 << 0
.equ GPIO.CFGLR.MODE_OUTPUT_2M , 2 << 0
.equ GPIO.CFGLR.MODE_OUTPUT_30M, 3 << 0

.equ AFIO, 0x40010000
.equ AFIO.pcfr1 , 0x4
.equ AFIO.exticr, 0x8

.equ RCC, 0x40021000
.equ RCC.ctrl     , 0x00
.equ RCC.cfgr0    , 0x04
.equ RCC.intr     , 0x08
.equ RCC.apb2prstr, 0x0c
.equ RCC.apb1prstr, 0x10
.equ RCC.ahbpcenr , 0x14
.equ RCC.apb2pcenr, 0x18
.equ RCC.apb1pcenr, 0x1c
.equ RCC.rstsckr  , 0x24
.equ RCC.APBxPCENR.IOPAEN, 1 << 2
.equ RCC.APBxPCENR.IOPCEN, 1 << 4
.equ RCC.APBxPCENR.IOPDEN, 1 << 5
.equ RCC.APB1PCENR.PWREN , 1 << 28
.equ RCC.APB1PCENR.I2C1EN, 1 << 21
.equ RCC.APB1PCENR.WWDGEN, 1 << 11
.equ RCC.APB1PCENR.TIM2EN, 1 <<  0

# Not in the manual, but found in
# https://github.com/openwch/ch32v003/blob/f9fd9c896feed53f29350e099e4a0cd9a8bdecca/EVT/EXAM/SRC/Debug/debug.c#L292-L322
.equ DEBUG_DATA0_ADDRESS, 0xe00000f4
.equ DEBUG_DATA1_ADDRESS, 0xe00000f8

.equ PFIC, 0xe000e000
.equ PFIC.isr1    , 0x000
.equ PFIC.isr2    , 0x004
.equ PFIC.ipr1    , 0x020
.equ PFIC.ipr2    , 0x024
.equ PFIC.ithresdr, 0x040
.equ PFIC.cfgr    , 0x048
.equ PFIC.cisr    , 0x04c
.equ PFIC.vtfidr  , 0x050
.equ PFIC.vtfaddr0, 0x060
.equ PFIC.vtfaddr1, 0x064
.equ PFIC.ienr1   , 0x100
.equ PFIC.ienr2   , 0x104
.equ PFIC.irer1   , 0x184
.equ PFIC.irer2   , 0x184
.equ PFIC.ipsr1   , 0x200
.equ PFIC.ipsr2   , 0x204
.equ PFIC.iprr1   , 0x280
.equ PFIC.iprr2   , 0x284
.equ PFIC.iactr1  , 0x300
.equ PFIC.iactr2  , 0x304
.equ PFIC.ipriorx , 0x400
.equ PFIC.sctlr   , 0xd10

.equ STK, 0xe000f000
.equ STK.ctlr , 0x00
.equ STK.sr   , 0x04
.equ STK.cntl , 0x08
.equ STK.cmplr, 0x10
.equ STK.CTLR.SWIE , 1 << 31
.equ STK.CTLR.STRE , 1 <<  3
.equ STK.CTLR.STCLK, 1 <<  2
.equ STK.CTLR.STIE , 1 <<  1
.equ STK.CTLR.STE  , 1 <<  0
