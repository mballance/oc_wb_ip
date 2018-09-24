/****************************************************************************
 * wb_dma_dev.c
 ****************************************************************************/
#include "wb_dma_dev.h"

static void wb_dma_dev_irq(struct uex_dev_s *devh) {
	wb_dma_dev_t *dev = (wb_dma_dev_t *)devh;
	uint32_t i;

	// Need to spin through the channels to determine
	// which channel to activate
	for (i=0; i<31; i++) {
		uex_mutex_lock(&dev->xfer_mutex[i]);
		if (dev->status[i] == 1) {
			// Check this channel's CSR
			uint32_t csr = uex_ioread32(&dev->regs->channels[i].csr);

			if ((csr & 1) == 0) {
				// Transfer is done
				dev->status[i] = 0;
				uex_cond_signal(&dev->xfer_cond[i]);
			}
		}
		uex_mutex_unlock(&dev->xfer_mutex[i]);
	}
}

void wb_dma_dev_init(struct uex_dev_s *devh) {
	uint32_t i;
	wb_dma_dev_t *dev = (wb_dma_dev_t *)devh;

	dev->regs = (wb_dma_regs_t *)uex_ioremap(dev->base.addr, 64, 0);
	dev->base.irq = &wb_dma_dev_irq;


	// Configure channel defaults
	for (i=0; i<8; i++) {
		// Enable for 256-byte chunks
		uint32_t sz_v = ((256/4) << 16);
		uint32_t csr = uex_ioread32(&dev->regs->channels[i].csr);

		uex_info_low(0, "csr[%d]=0x%08x addr=%p", i, csr,
				&dev->regs->channels[i].csr);

		csr |= (1 << 18); // enable completion interrupt
		csr &= ~(1); // disable the channel
		uex_iowrite32(csr, &dev->regs->channels[i].csr);

		uex_iowrite32(sz_v, &dev->regs->channels[i].size);

		// Configure address mask
		uex_iowrite32(0xFFFFFFFC, &dev->regs->channels[i].src_msk);
		uex_iowrite32(0xFFFFFFFC, &dev->regs->channels[i].dst_msk);
	}

	// Route enabled channels to INTA
	uex_iowrite32(0xFFFFFFFF, &dev->regs->int_msk_a);
//	uex_iowrite32(0xFFFFFFFF, &dev->regs->int_src_a);

	uex_iowrite32(0x0, &dev->regs->int_msk_b);
//	uex_iowrite32(0x0, &dev->regs->int_src_b);

	// Initialize thread-control fields
	for (i=0; i<31; i++) {
		uex_mutex_init(&dev->busy_mutex[i]);
		uex_mutex_init(&dev->xfer_mutex[i]);
		uex_cond_init(&dev->xfer_cond[i]);
	}

	// Find the device and connect the interrupt based on the base address
//	dev = uex_find_device(base);
//	uex_set_irq_handler(dev->irqs[0], &wb_dma_uex_irq, drv);
}

void wb_dma_dev_single_xfer(
		uint32_t				devid,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				inc_src,
		uint32_t				dest,
		uint32_t				inc_dst,
		uint32_t				sz) {
	wb_dma_dev_t	*drv = (wb_dma_dev_t *)uex_get_device(devid);
	uint32_t csr, sz_v;
	uex_mutex_lock(&drv->xfer_mutex[channel]);

	// Program channel registers
	csr = uex_ioread32(&drv->regs->channels[channel].csr);

	csr |= (1 << 18); // interrupt on done
	csr |= (1 << 17); // interrupt on error
	csr =  (inc_src)?(csr | (1 << 4)):(csr & ~(1 << 4));
	csr =  (inc_dst)?(csr | (1 << 3)):(csr & ~(1 << 3));

	csr |= (1 << 2); // use interface 0 for source
	csr |= (1 << 1); // use interface 1 for destination

	csr |= (1 << 0); // enable channel

	// Setup source and destination addresses
	uex_iowrite32(src, &drv->regs->channels[channel].src);
	uex_iowrite32(dest, &drv->regs->channels[channel].dst);

	sz_v = uex_ioread32(&drv->regs->channels[channel].size);
	sz_v &= ~(0xFFF); // Clear tot_sz
	sz_v |= (sz & 0xFFF);
	uex_iowrite32(sz_v, &drv->regs->channels[channel].size);

	// Start the transfer
	uex_iowrite32(csr, &drv->regs->channels[channel].csr);

	drv->status[channel] = 1;

	// Wait for completion
	uex_cond_wait(&drv->xfer_cond[channel], &drv->xfer_mutex[channel]);
	uex_mutex_unlock(&drv->xfer_mutex[channel]);
}

