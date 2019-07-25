#include "util.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "uart.h"
#include "leds.h"

int main(){
    char tmp = 0x55;
    TXCTRL = TXCNT(4) | TXEN;
    RXCTRL = RXCNT(4) | RXEN;
    DIV = 50000000 / 115200; // for 50M clk & 115200 baud rate

    int readStatus, writeStatus;
    while(1){
        readStatus = RXDATA;
        if(readStatus & RXFIFO_EMPTY){
            asm("nop");
            asm("nop");
            asm("nop");
            asm("nop");
        }else{
            writeStatus = TXDATA;
            while(writeStatus & TXFIFO_FULL){
                asm("nop");
                asm("nop");
                asm("nop");
                asm("nop");
                writeStatus = TXDATA;
            }
            TXDATA = (readStatus & 0xFF) + 1;
        }
    }
}
