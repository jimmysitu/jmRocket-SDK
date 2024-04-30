set pagination off
set logging file gdb.log
set logging on
target remote localhost:3333
load

break main
break __gcov_exit

break test_gcov.c:25

continue
