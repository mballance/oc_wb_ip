
#ifndef INCLUDED_WB_UART16550_DRV_H
#define INCLUDED_WB_UART16550_DRV_H
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

struct wb_uart16550_drv_s;

#define WB_UART16550_NONBLOCK (1 << 0)
#define WB_UART16550_INTMODE  (2 << 0)
#define WB_UART16550_FIFO_SZ  16

typedef struct wb_uart16550_drv_s {
	uint32_t			base;
	uint32_t			flags;


	// Tx buffer for interrupt mode
	uint8_t				tx_buf[64];
	uint32_t			tx_buf_head;
	uint32_t			tx_buf_tail;
	// Estimated Tx FIFO fill
	uint32_t			est_tx_fill;

	// Rx buffer for interrupt mode
	uint8_t				rx_buf[64];
	uint32_t			rx_buf_head;
	uint32_t			rx_buf_tail;
} wb_uart16550_drv_t;

void wb_uart16550_drv_init(
		wb_uart16550_drv_t		*drv,
		uint32_t				base,
		uint16_t				divisor);

void wb_uart16550_drv_setflags(
		wb_uart16550_drv_t		*drv,
		uint32_t				flags);

void wb_uart16550_drv_clrflags(
		wb_uart16550_drv_t		*drv,
		uint32_t				flags);

int32_t wb_uart16550_drv_write(
		wb_uart16550_drv_t		*drv,
		uint8_t					*data,
		uint32_t				sz);

int32_t wb_uart16550_drv_read(
		wb_uart16550_drv_t		*drv,
		uint8_t					*data,
		uint32_t				sz);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_UART16550_DRV_H */
