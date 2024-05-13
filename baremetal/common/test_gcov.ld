/*======================================================================*/
/* Proxy kernel linker script                                           */
/*======================================================================*/
/* This is the linker script used when building the proxy kernel. */

/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY
{
  ram (rxaiw) : ORIGIN = 0x80000000, LENGTH = 64K
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

  /* text: test code section */
  . = 0x80000000;
  .text.init : { *(.text.init) } > ram

  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }

  .text : { 
    *(.text)
  } > ram

  .ctors : {
    __ctor_list = . ;
    *(SORT(.ctors.*))
    *(.ctors)
    __ctor_end = . ;
    . = ALIGN(16);
  } > ram


  /* data segment */
  .data : { *(.data) } > ram

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > ram

  .gcov : {
    PROVIDE (__gcov_start = .);
    KEEP (*(.gcda))
    PROVIDE (__gcov_end = .);
  } > ram

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } > ram
  .bss : { *(.bss) } > ram

  /* thread-local data segment */
  .tdata :
  {
    _tls_data = .;
    *(.tdata.begin)
    *(.tdata)
    *(.tdata.end)
  } > ram
  .tbss :
  {
    *(.tbss)
    *(.tbss.end)
  } > ram

  /* End of uninitalized data segement */
  _end = .;
}

