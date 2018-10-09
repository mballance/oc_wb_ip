/****************************************************************************
 * wb_uart_uex_drv.c
 ****************************************************************************/
#include "uex.h"
#include "wb_uart_dev.h"

static void wb_uart_dev_irq(struct uex_dev_s *devh) {
	wb_uart_dev_t *dev = (wb_uart_dev_t *)devh;
	uint32_t iir;

	uex_info_low(0, "--> wb_uart_dev_irq");
	iir = uex_ioread32(&dev->regs->iir);

	if ((iir & 0x1) == 0) {
		uint32_t code = ((iir >> 1) & 7);
		// Active interrupt
		switch (code) {
		// THR empty
		case 1:
//			uex_mutex_lock(&dev->m_tx_mutex);
			uex_cond_signal(&dev->m_tx_cond);
//			uex_mutex_unlock(&dev->m_tx_mutex);
			break;

		// Rx data available
		case 2:
			break;

		default:
			break;

		}
	}

	uex_info_low(0, "<-- wb_uart_dev_irq");
}

void wb_uart_dev_tx(uint32_t devid, int c) {
	wb_uart_dev_t *dev = (wb_uart_dev_t *)uex_get_device(devid);
	uint8_t val;
	uint32_t know_have_space = 0;

	// If we know we've written 16 bytes in the past,
	// the wait for the device to catch up
	while (dev->m_tx_pending >= 16) {
		// Read the LSR to see if the THR is empty
		uint32_t lsr = uex_ioread8(&dev->regs->lsr);

		if ((lsr >> 5) & 1) {
			uex_info_low(0, "Tx is available");
			dev->m_tx_pending = 0;
		} else {
			uex_info_low(0, "--> Waiting for Tx-empty interrupt");
			uex_mutex_lock(&dev->m_tx_mutex);
			uex_cond_wait(&dev->m_tx_cond, &dev->m_tx_mutex);
			uex_mutex_unlock(&dev->m_tx_mutex);
			uex_info_low(0, "<-- Waiting for Tx-empty interrupt");
		}
	}

	uex_iowrite8(c, &dev->regs->thr);
	dev->m_tx_pending++;
}

int wb_uart_dev_getc(uint32_t devid) {
	wb_uart_dev_t *dev = (wb_uart_dev_t *)uex_get_device(devid);
	uint8_t val;

	do {
		val = uex_ioread8(&dev->regs->lsr);
	} while ((val & 1) == 0);

	val = uex_ioread8(&dev->regs->rbr);

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

static void wb_uart_dev_set_div(wb_uart_dev_t *dev) {
	uint8_t val;
	uint32_t clk_div;

	clk_div = (dev->clk_hz / dev->baud);
	clk_div /= 16;

	// Initialize the UART to 115200
	val = uex_ioread8(&dev->regs->lcr); // read LCR
	val |= 0x80;
	uex_iowrite8(val, &dev->regs->lcr);

	uex_iowrite8((clk_div >> 8), &dev->regs->dlb2); // DL MSB
	uex_iowrite8(clk_div, &dev->regs->dlb1); // DL LSB 14=115200

	val &= (~0x80);
	uex_iowrite8(val, &dev->regs->lcr);
}

//static int wb_uart_uex_drv_ioctl(
//		uex_dev_t				*dev,
//		uint32_t				cmd,
//		void					*arg) {
//	wb_uart_uex_drv_t *drv = (wb_uart_uex_drv_t *)dev->data;
//
//	switch (cmd) {
//		case WB_UART_GET_BAUD_RATE:
//			*((uint32_t *)arg) = drv->baud;
//			break;
//		case WB_UART_SET_BAUD_RATE:
//			drv->baud = *((uint32_t *)arg);
//			if (drv->baud && drv->clk_hz) {
//				wb_uart_uex_drv_set_div(drv);
//			}
//			break;
//		case WB_UART_GET_CLK_RATE:
//			*((uint32_t *)arg) = drv->clk_hz;
//			break;
//		case WB_UART_SET_CLK_RATE:
//			drv->clk_hz = *((uint32_t *)arg);
//			if (drv->baud && drv->clk_hz) {
//				wb_uart_uex_drv_set_div(drv);
//			}
//			break;
//		default:
//			return -1;
//	}
//	return 0;
//}

void wb_uart_dev_init(struct uex_dev_s *devh) {
	uint32_t clk_div = 14; // 25 mhz clock
	uint8_t val;
	wb_uart_dev_t *dev = (wb_uart_dev_t *)devh;

	dev->base.irq = &wb_uart_dev_irq;

//	dev->api.write = &wb_uart_uex_drv_write;
//	dev->api.read = &wb_uart_uex_drv_read;
//	dev->api.ioctl = &wb_uart_uex_drv_ioctl;

//	memset(drv, 0, sizeof(wb_uart_uex_drv_t));
	dev->regs = (wb_uart_regs_t *)uex_ioremap(
			dev->base.addr, sizeof(wb_uart_regs_t), 0);

	dev->m_tx_pending = 0;

	uex_mutex_init(&dev->m_tx_mutex);
	uex_cond_init(&dev->m_tx_cond);

	uex_mutex_init(&dev->m_rx_mutex);
	uex_cond_init(&dev->m_rx_cond);

//	dev->baud = 115200;
	dev->baud = 19200;
	dev->clk_hz = 50000000;

	wb_uart_dev_set_div(dev);

	// Enable interrupts
	uex_iowrite8(3, &dev->regs->ier);

	// Set Rx FIFO level to 1
	uex_iowrite8(0, &dev->regs->iir);
}

