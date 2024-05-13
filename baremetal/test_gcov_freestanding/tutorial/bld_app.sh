#!/bin/bash

export PATH=/usr/local/gcc-13.2.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/gcc-13.2.0/lib64:$LD_LIBRARY_PATH


#export CC=gcc-13.2.0
export CC=gcc-13

$CC --version
$CC --coverage -fprofile-info-section -c main.c
$CC --coverage -fprofile-info-section -c app.c

#objdump -h app.o
if ! [ -f linkcmds ]; then
    ld --verbose | sed '1,/^===/d' | sed '/^===/d' > linkcmds
#  .gcov_info      :
#  {
#    PROVIDE (__gcov_info_start = .);
#    KEEP (*(.gcov_info))
#    PROVIDE (__gcov_info_end = .);
#  }

fi

$CC --coverage main.o app.o -T linkcmds -Wl,-Map,app.map


