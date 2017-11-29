/****************************************************************************
 * wb_uart_uex_drv.c
 ****************************************************************************/
#include "wb_uart_uex_drv.h"
#include "uex.h"

void wb_uart_uex_drv_putc(wb_uart_uex_drv_t *drv, int c) {
	uint8_t val;

	do {
		val = uex_ioread8(&drv->regs->lsr); // read LSR;
	} while ((val & 0x40) == 0);

	uex_iowrite8(c, &drv->regs->thr);
}

int wb_uart_uex_drv_getc(wb_uart_uex_drv_t *drv) {
	uint8_t val;

	do {
		val = uex_ioread8(&drv->regs->lsr);
	} while ((val & 1) == 0);

	val = uex_ioread8(&drv->regs->rbr);

	return val;
}

static int wb_uart_uex_drv_write(
		uex_dev_t				*dev,
		void					*data,
		size_t					sz,
		int						flags) {

	return 1;
}

static int wb_uart_uex_drv_read(
		uex_dev_t				*dev,
		void					*data,
		size_t					sz,
		int						flags) {

	return 1;
}

static void wb_uart_uex_drv_set_div(wb_uart_uex_drv_t *drv) {
	uint8_t val;
	uint32_t clk_div;

	clk_div = (drv->clk_hz / drv->baud);
	clk_div /= 16;

	// Initialize the UART to 115200
	val = uex_ioread8(&drv->regs->lcr); // read LCR
	val |= 0x80;
	uex_iowrite8(val, &drv->regs->lcr);

	uex_iowrite8((clk_div >> 8), &drv->regs->dlb2); // DL MSB
	uex_iowrite8(clk_div, &drv->regs->dlb1); // DL LSB 14=115200

	val &= (~0x80);
	uex_iowrite8(val, &drv->regs->lcr);
}

static int wb_uart_uex_drv_ioctl(
		uex_dev_t				*dev,
		uint32_t				cmd,
		void					*arg) {
	wb_uart_uex_drv_t *drv = (wb_uart_uex_drv_t *)dev->data;

	switch (cmd) {
		case WB_UART_GET_BAUD_RATE:
			*((uint32_t *)arg) = drv->baud;
			break;
		case WB_UART_SET_BAUD_RATE:
			drv->baud = *((uint32_t *)arg);
			if (drv->baud && drv->clk_hz) {
				wb_uart_uex_drv_set_div(drv);
			}
			break;
		case WB_UART_GET_CLK_RATE:
			*((uint32_t *)arg) = drv->clk_hz;
			break;
		case WB_UART_SET_CLK_RATE:
			drv->clk_hz = *((uint32_t *)arg);
			if (drv->baud && drv->clk_hz) {
				wb_uart_uex_drv_set_div(drv);
			}
			break;
		default:
			return -1;
	}
	return 0;
}

void wb_uart_uex_drv_init(uex_dev_t *dev) {
	uint32_t clk_div = 14; // 25 mhz clock
	uint8_t val;
	wb_uart_uex_drv_t *drv = (wb_uart_uex_drv_t *)dev->data;

	dev->api.write = &wb_uart_uex_drv_write;
	dev->api.read = &wb_uart_uex_drv_read;
	dev->api.ioctl = &wb_uart_uex_drv_ioctl;

	memset(drv, 0, sizeof(wb_uart_uex_drv_t));
	drv->regs = (wb_uart_regs_t *)uex_ioremap(dev->addr, sizeof(wb_uart_regs_t), 0);

	drv->baud = 115200;
	drv->clk_hz = 0;

}

