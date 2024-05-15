#!/bin/bash

export PATH=/usr/local/gcc-13.2.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/gcc-13.2.0/lib64:$LD_LIBRARY_PATH


#export CC=gcc-13.2.0
export CC=gcc-13

# Without gcov
$CC -c -ffunction-sections -fdata-sections main.c
$CC -c app.c
$CC main.o app.o -T linkcmds -Wl,-Map,app.map -Wl,--gc-sections -o app.out
objdump -D -S app.out > app.out.dump

$CC --version
$CC --coverage -fprofile-info-section -DGCOV_TEST -c main.c
$CC --coverage -fprofile-info-section -c app.c

#objdump -h app.o
if ! [ -f linkcmds ]; then
    ld --verbose | sed '1,/^===/d' | sed '/^===/d' > linkcmds

# Add this section to linkcmds, right after .rodata
#  .gcov_info      :
#  {
#    PROVIDE (__gcov_info_start = .);
#    KEEP (*(.gcov_info))
#    PROVIDE (__gcov_info_end = .);
#  }

fi

# With gcov
$CC --coverage main.o app.o -T linkcmds -Wl,-Map,app.gcov.map -o app.gcov.out
objdump -D -S app.gcov.out > app.gcov.out.dump

