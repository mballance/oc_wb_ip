/****************************************************************************
 * wb_simple_pic_dev.c
 ****************************************************************************/
#include "wb_simple_pic_dev.h"
#include <stdio.h>

typedef struct wb_simple_pic_regs_s {
	uint32_t		edge;
	uint32_t		polarity;
	uint32_t		mask;
	uint32_t		pending;

} wb_simple_pic_regs_t;

void wb_simple_pic_dev_init(uex_dev_t *devh) {
	wb_simple_pic_dev_t *dev = (wb_simple_pic_dev_t *)devh;
	dev->regs = (wb_simple_pic_regs_t *)uex_ioremap(dev->base.addr, 16, 0);

	uex_iowrite32(0xFFFFFFFF, &dev->regs->mask); // All are initially masked
//	uex_iowrite32(0, &dev->regs->edge);
	uex_iowrite32(0xFFFFFFFF, &dev->regs->polarity); // Active high
	uex_iowrite32(0xFFFFFFFF, &dev->regs->pending); // Clear all active interrupts
}

void wb_simple_pic_dev_en_irq(
		uint32_t				devid,
		uint32_t				irq,
		uint32_t				en) {
	wb_simple_pic_dev_t *dev = (wb_simple_pic_dev_t *)uex_get_device(devid);

	uint32_t mask = uex_ioread32(&dev->regs->mask);

	if (en) {
		mask &= ~(1 << irq);
	} else {
		mask |= (1 << irq);
	}

	uex_info_low(0, "pic_dev_en: irq=%d mask=0x%08x addr=%p",
			irq, mask, &dev->regs->mask);

	uex_iowrite32(mask, &dev->regs->mask);
}

uint32_t wb_simple_pic_dev_get_pending(
		uint32_t				devid) {
	wb_simple_pic_dev_t *dev = (wb_simple_pic_dev_t *)uex_get_device(devid);

	return uex_ioread32(&dev->regs->pending);
}

void wb_simple_pic_dev_clr_pending(
		uint32_t				devid,
		uint32_t				irq) {
	wb_simple_pic_dev_t *dev = (wb_simple_pic_dev_t *)uex_get_device(devid);
	uint32_t ack = (1 << irq);

	uex_iowrite32(ack, &dev->regs->pending);
}
