set pagination off
set logging file gdb.log
set logging on
target remote localhost:3333
load

break main
break fun1
#break fun2
break dump_gcov_info
break tohost_exit
break exit

break fread
break free

continue

dump binary memory gcov-stream.bin __gcda_start __gcda_end
