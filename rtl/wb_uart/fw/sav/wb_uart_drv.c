/****************************************************************************
 * wb_uart_drv.c
 ****************************************************************************/
#include "wb_uart_drv.h"
#include <string.h>

void wb_uart_drv_init(
		wb_uart_drv_t		*drv,
		void				*base,
		uint32_t			clk_div) {
	uint8_t val;
	memset(drv, 0, sizeof(wb_uart_drv_t));
	drv->base = (uint8_t *)base;

	val = drv->base[3]; // read LCR
	val |= 0x80;
	drv->base[3] = val;

	drv->base[1] = (clk_div >> 8); // DL MSB
	drv->base[0] = clk_div; // DL LSB 14=115200

	val &= (~0x80);
	drv->base[3] = val;

}

void wb_uart_drv_putc(wb_uart_drv_t *drv, int c) {
	uint8_t val;

	do {
		val = drv->base[5]; // read LSR;
	} while ((val & 0x40) == 0);

	drv->base[0] = c;
}

int wb_uart_drv_getc(wb_uart_drv_t *drv) {
	uint8_t val;

	do {
		val = drv->base[5];
	} while ((val & 1) == 0);

	val = drv->base[0];

	return val;
}
