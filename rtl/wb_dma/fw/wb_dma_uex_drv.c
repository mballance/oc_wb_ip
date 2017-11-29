/****************************************************************************
 * wb_dma_uex_drv.c
 ****************************************************************************/
#include "wb_dma_uex_drv.h"

static void wb_dma_uex_irq(void *ud) {
	wb_dma_uex_drv_t *drv = (wb_dma_uex_drv_t *)ud;
	uint32_t i;

	// Need to spin through the channels to determine
	// which channel to activate
	for (i=0; i<31; i++) {
		uex_mutex_lock(&drv->xfer_mutex[i]);
		if (drv->status[i] == 1) {
			// Check this channel's CSR
			uint32_t csr = uex_ioread32(&drv->regs->channels[i].csr);

			if ((csr & 1) == 0) {
				// Transfer is done
				drv->status[i] = 0;
				uex_cond_signal(&drv->xfer_cond[i]);
			}
		}
		uex_mutex_unlock(&drv->xfer_mutex[i]);
	}
}

void wb_dma_uex_drv_init(
		wb_dma_uex_drv_t		*drv,
		void					*base) {
	uint32_t i;
	uex_device_t *dev;

	memset(drv, 0, sizeof(wb_dma_drv_t));
	drv->regs = (wb_dma_regs_t *)uex_ioremap(base, 64, 0);

	// Route enabled channels to INTA
	uex_iowrite32(&drv->regs->int_msk_a, 0xFFFFFFFF);
	uex_iowrite32(&drv->regs->int_src_a, 0xFFFFFFFF);

	for (i=0; i<31; i++) {
		// Enable for 256-byte chunks
		uint32_t sz_v = ((256/4) << 16);

		uex_iowrite32(&drv->regs->channels[i].size, sz_v);

		// Configure address mask
		uex_iowrite32(&drv->regs->channels[i].src_msk, 0xFFFFFFFC);
		uex_iowrite32(&drv->regs->channels[i].dst_msk, 0xFFFFFFFC);
	}

	// Initialize thread-control fields
	for (i=0; i<31; i++) {
		uex_mutex_init(&drv->busy_mutex[i]);
		uex_mutex_init(&drv->xfer_mutex[i]);
		uex_cond_init(&drv->xfer_cond[i]);
	}

	// Find the device and connect the interrupt based on the base address
	dev = uex_find_device(base);
	uex_set_irq_handler(dev->irqs[0], &wb_dma_uex_irq, drv);
}

void wb_dma_uex_drv_single_xfer(
		wb_dma_uex_drv_t		*drv,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				inc_src,
		uint32_t				dest,
		uint32_t				inc_dst,
		uint32_t				sz) {
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
	uex_iowrite32(&drv->regs->channels[channel].src, src);
	uex_iowrite32(&drv->regs->channels[channel].dst, dest);

	sz_v = uex_ioread32(&drv->regs->channels[channel].size);
	sz_v &= ~(0xFFF); // Clear tot_sz
	sz_v |= (sz & 0xFFF);
	uex_iowrite32(&drv->regs->channels[channel].size, sz_v);

	// Start the transfer
	uex_iowrite32(&drv->regs->channels[channel].csr, csr);

	drv->status[channel] = 1;

	// Wait for completion
	uex_cond_wait(&drv->xfer_cond[channel], &drv->xfer_mutex[channel]);
	uex_mutex_unlock(&drv->xfer_mutex[channel]);
}

