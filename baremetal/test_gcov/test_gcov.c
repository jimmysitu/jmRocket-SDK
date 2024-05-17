#include "util.h"
#include <stdlib.h>
#include <gcov.h>
#include "test_gcov.h"

/* The start and end symbols are provided by the linker script.  We use the
   array notation to avoid issues with a potential small-data area.  */

extern const struct gcov_info *const __gcov_info_start[];
extern const struct gcov_info *const __gcov_info_end[];

extern uint8_t __gcda_start[];
extern uint8_t __gcda_end[];


#define GCDA_MAX_SIZE  2048


/* This function shall produce a reliable in order byte stream to transfer the
   gcov information from the target to the host system.  */

static void
dump (const void *d, unsigned n, void *arg)
{
  static uint8_t *gcda_ptr = __gcda_start;
  if (gcda_ptr <= __gcda_end){
    memcpy(gcda_ptr, d, n);
    gcda_ptr = gcda_ptr + n;
  }
}

/* The filename is serialized to a gcfn data stream by the
   __gcov_filename_to_gcfn() function.  The gcfn data is used by the
   "merge-stream" subcommand of the "gcov-tool" to figure out the filename
   associated with the gcov information. */

static void
filename (const char *f, void *arg)
{
  __gcov_filename_to_gcfn (f, dump, arg);
}

/* The __gcov_info_to_gcda() function may have to allocate memory under
   certain conditions.  Simply try it out if it is needed for your application
   or not.  */

static void *
allocate (unsigned length, void *arg)
{
  (void)arg;
  return malloc (length);
}

/* Dump the gcov information of all translation units.  */

static void
dump_gcov_info (void)
{
  const struct gcov_info *const *info = __gcov_info_start;
  const struct gcov_info *const *end = __gcov_info_end;

  /* Obfuscate variable to prevent compiler optimizations.  */
  __asm__ ("" : "+r" (info));

  while (info != end)
  {
    void *arg = NULL;
    __gcov_info_to_gcda (*info, filename, dump, allocate, arg);
    ++info;
  }
}


void fun1(){
    static int a = 1;
    a++;
}

int fun2(int b){
    if(b > 5){
        return b;
    }else{
        return 0;
    }
}

int main(){

    fun1();

    volatile int acc = 0;
    for(int i=0; i<100; i++) {
        acc = acc + fun2(i);
    }

    dump_gcov_info();
    return 0;
}
