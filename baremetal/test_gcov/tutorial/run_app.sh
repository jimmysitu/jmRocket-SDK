#!/bin/bash

rm -f app.gcda main.gcda
echo "" | ./app.gcov.out 2>gcda-0.txt
./app.gcov.out <gcda-0.txt 2>gcda-1.txt | tee gcda-0.bin | gcov-tool-13 merge-stream
gcov-13 -bc app.c

./app.gcov.out <gcda-1.txt 2>gcda-2.txt | tee gcda-1.bin | gcov-tool-13 merge-stream
gcov-13 -bc app.c
