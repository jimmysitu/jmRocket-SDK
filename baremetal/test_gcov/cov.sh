#!/bin/bash

rm *.gcda
cat gcov-stream.bin | riscv64-unknown-elf-gcov-tool merge-stream
#riscv64-unknown-elf-gcov -bc test_gcov.c
#riscv64-unknown-elf-gcov -bc syscalls.c

lcov -d . -o test_gcov.info -b . -c \
    --rc lcov_branch_coverage=1 \
    --gcov-tool /opt/riscv/bin/riscv64-unknown-elf-gcov

genhtml -rc genhtml_branch_coverage=1 test_gcov.info -o cov_result

gcovr --txt-metric line --txt-metric branch --txt-metric decision \
    --html-nested -r . \
    --gcov-executable /opt/riscv/bin/riscv64-unknown-elf-gcov \
    --gcov-ignore-errors no_working_dir_found \
    --gcov-ignore-parse-error negative_hits.warn \
    -o gcovr_result.html
