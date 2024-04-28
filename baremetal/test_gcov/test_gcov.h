#ifndef __UART_H
#define __UART_H

#define TXDATA  (*(volatile unsigned long*)0x10014000)
#define RXDATA  (*(volatile unsigned long*)0x10014004)
#define TXCTRL  (*(volatile unsigned long*)0x10014008)
#define RXCTRL  (*(volatile unsigned long*)0x1001400c)
#define IE      (*(volatile unsigned long*)0x10014010)
#define IP      (*(volatile unsigned long*)0x10014014)
#define DIV     (*(volatile unsigned long*)0x10014018)

// TXDATA
#define TXFIFO_FULL     (1<<31)

// RXDATA
#define RXFIFO_EMPTY    (1<<31)

// TXCTRL
#define TXEN            (1<<0)
#define NSTOP           (1<<1)
#define TXCNT(cnt)      ((0x7 & cnt)<<16)

// RXCTRL
#define RXEN            (1<<0)
#define RXCNT(cnt)      ((0x7 & cnt)<<16)

#endif
