ENTRY(_start)

MEMORY
{
	/* FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 16K */
	FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 16K
	RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 2K
}

SECTIONS
{
    .init :
    { 
      . = ALIGN(4);
      KEEP(*(SORT_NONE(.init)))
      . = ALIGN(4);
    } >FLASH AT>FLASH

    .text :
    {
      . = ALIGN(4);
      *(.text .text.*)
      . = ALIGN(4);
    } >FLASH AT>FLASH 

    .rodata :
    {
      . = ALIGN(4);
      *(.rodata .rodata.*)
      . = ALIGN(4);
    } >FLASH AT>FLASH 

    .data :
    {
      . = ALIGN(4);
      *(.data .data.*)
      . = ALIGN(4);
    } >RAM AT>FLASH

    .bss :
    {
      . = ALIGN(4);
      *(.bss .bss.*)
      . = ALIGN(4);
    } >RAM AT>FLASH
}
