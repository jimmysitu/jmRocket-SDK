#!/bin/bash

rm -f app.gcda main.gcda
echo "" | ./a.out 2>gcda-0.txt
./a.out <gcda-0.txt 2>gcda-1.txt | gcov-tool-13 merge-stream
gcov-13 -bc app.c

./a.out <gcda-1.txt 2>gcda-2.txt | gcov-tool-13 merge-stream
gcov-13 -bc app.c