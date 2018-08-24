/*
 * wb_periph_subsys.h
 *
 *  Created on: Aug 22, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_WB_PERIPH_SUBSYS_H
#define INCLUDED_WB_PERIPH_SUBSYS_H
#include "wb_dma_dev.h"
#include "wb_uart_dev.h"
#include "wb_simple_pic_dev.h"

typedef struct wb_periph_subsys_s {
	wb_dma_dev_t			dma;
	wb_uart_dev_t			uart;
	wb_simple_pic_dev_t		pic;

} wb_periph_subsys_t;

#define WB_PERIPH_SUBSYS_DEV_STATIC_INIT(__name, __base_addr) { \
	.dma = WB_DMA_DEV_STATIC_INIT(__name ".dma", (__base_addr) + 0x00000000), \
	.uart = WB_UART_DEV_STATIC_INIT(__name ".uart", (__base_addr) + 0x00000400), \
	.pic = WB_SIMPLE_PIC_STATIC_INIT(__name ".pic", (__base_addr) + 0x00000440) \
}

#define WB_PERIPH_SUBSYS_DEVICES(__base) \
		&__base.dma.base, \
		&__base.uart.base, \
		&__base.pic.base

#define WB_PERIPH_SUBSYS_DEVID(__base) \
		__base ## _ ## dma,  \
		__base ## _ ## uart, \
		__base ## _ ## pic   \



#endif /* INCLUDED_WB_PERIPH_SUBSYS_H */
