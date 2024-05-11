#!/bin/bash

gcc-13 --coverage -fprofile-info-section -c main.c
gcc-13 --coverage -fprofile-info-section -c app.c

objdump -h app.o
ld --verbose | sed '1,/^===/d' | sed '/^===/d' > linkcmds

gcc-13 --coverage main.o app.o -T linkcmds -Wl,-Map,app.map


