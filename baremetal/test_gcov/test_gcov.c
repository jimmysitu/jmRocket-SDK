#include "util.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "test_gcov.h"

void fun1(){
    int a = 1;
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
    fun2(4);
}
