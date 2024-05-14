#include "util.h"
#include <gcov.h>
#include "test_gcov.h"

extern const struct gcov_info *const __gcov_info_start[];
extern const struct gcov_info *const __gcov_info_end[];


void fun1(){
    static int a = 1;
    a++;
}

int fun2(int b){
    if(b > 5){
        return b;
    }else{
        return 0;
    }
}

int main(){

    fun1();

    volatile int acc = 0;
    for(int i=0; i<100; i++) {
        acc = acc + fun2(i);
    }

    return 0;
}
