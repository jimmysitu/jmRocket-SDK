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

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
  ram (rxaiw) : ORIGIN = 0x80000000, LENGTH = 64K
}

SECTIONS
{

  __stack_size = DEFINED(__stack_size) ? __stack_size : 2K;
  
  /* text: test code section */
  . = 0x80000000;
  .text.init : { *(.text.init) }

  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }

  . = ALIGN(0x1000);
  .text : { *(.text) }
  
  . = ALIGN(8);
  .gcov_info      :
  {
    PROVIDE (__gcov_info_start = .);
    KEEP (*(.gcov_info))
    PROVIDE (__gcov_info_end = .);
  }

  /* Memory block for gcda stream */
  . = ALIGN(8);
  .gcda           :
  {
    PROVIDE (__gcda_start = .);
    KEEP (*(.gcda))
    . = __gcda_start + 2048;
    PROVIDE (__gcda_end = .);
  }

  /* data segment */
  .data : { *(.data) }

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > ram

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } > ram
  .bss : { *(.bss) }

  /* thread-local data segment */
  .tdata :
  {
    PROVIDE( _tdata_begin = . );
    *(.tdata)
    PROVIDE( _tdata_end = . );
  } > ram
  .tbss :
  {
    *(.tbss)
    PROVIDE( _tbss_end = . );
  } > ram

  /* End of uninitalized data segement */
  _end = .;
  
  .stack ORIGIN(ram) + LENGTH(ram) - __stack_size :
  {
    PROVIDE( _heap_end = . );
    . = __stack_size;
    PROVIDE( _sp = . );
  }


}

