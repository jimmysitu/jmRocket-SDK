#!/bin/bash

cat gcov-stream.bin | riscv64-unknown-elf-gcov-tool merge-stream
riscv64-unknown-elf-gcov -bc test_gcov.c
riscv64-unknown-elf-gcov -bc syscalls.c
