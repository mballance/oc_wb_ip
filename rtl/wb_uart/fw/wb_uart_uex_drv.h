/****************************************************************************
 * wb_uart_uex_drv.h
 ****************************************************************************/
#ifndef INCLUDED_WB_UART_UEX_DRV_H
#define INCLUDED_WB_UART_UEX_DRV_H
#include <stdint.h>
#include "wb_uart_regs.h"

typedef enum {
	WB_UART_SET_CLK_RATE,
	WB_UART_GET_CLK_RATE,
	WB_UART_SET_BAUD_RATE,
	WB_UART_GET_BAUD_RATE
};

typedef struct wb_uart_uex_drv_s {
	wb_uart_regs_t			*regs;
	uint32_t				clk_hz;
	uint32_t				baud;

} wb_uart_uex_drv_t;

void wb_uart_uex_drv_init(
		wb_uart_uex_drv_t 	*drv,
		void				*base,
		uint32_t			clk_div);

void wb_uart_uex_drv_putc(wb_uart_uex_drv_t *drv, int c);

int wb_uart_uex_drv_getc(wb_uart_uex_drv_t *drv);


#endif /* INCLUDED_WB_UART_UEX_DRV_H */
