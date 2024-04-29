set pagination off
set logging file gdb.log
set logging on
target remote localhost:3333
load
break main
continue
