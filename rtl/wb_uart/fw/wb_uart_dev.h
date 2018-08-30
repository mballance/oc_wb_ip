/****************************************************************************
 * wb_uart_uex_drv.h
 ****************************************************************************/
#ifndef INCLUDED_WB_UART_UEX_DRV_H
#define INCLUDED_WB_UART_UEX_DRV_H
#include <stdint.h>
#include <uex.h>
#include "wb_uart_regs.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	WB_UART_SET_CLK_RATE,
	WB_UART_GET_CLK_RATE,
	WB_UART_SET_BAUD_RATE,
	WB_UART_GET_BAUD_RATE
} wb_uart_ioctl_e;

typedef struct wb_uart_dev_s {
	uex_dev_t				base;
	wb_uart_regs_t			*regs;
	uint32_t				clk_hz;
	uint32_t				baud;

	uint32_t				m_tx_pending;
	uex_mutex_t				m_tx_mutex;
	uex_cond_t				m_tx_cond;

	uex_mutex_t				m_rx_mutex;
	uex_cond_t				m_rx_cond;
} wb_uart_dev_t;

#define WB_UART_DEV_STATIC_INIT(__name, __base_addr) { \
	.base = UEX_DEV_STATIC_INIT(__name, __base_addr, wb_uart_dev_init) \
}

void wb_uart_dev_init(struct uex_dev_s *devh);

void wb_uart_dev_tx(uint32_t devid, int c);

int wb_uart_dev_rx(uint32_t devid);

void wb_uart_dev_mem2tx(uint32_t devid, void *addr, uint32_t sz);

void wb_uart_dev_rx2mem(uint32_t devid, void *addr, uint32_t sz);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_UART_UEX_DRV_H */
