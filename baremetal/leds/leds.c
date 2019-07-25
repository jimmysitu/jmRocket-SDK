#include"util.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include "leds.h"

int main()
{
    LEDEN = 0x0F;
    while(1){
        LEDS = 0xAA;
        for(long i=0; i < 800000; i++){
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
        }
        LEDS = 0x55;
        for(long i=0; i < 800000; i++){
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
        }
    }
}
