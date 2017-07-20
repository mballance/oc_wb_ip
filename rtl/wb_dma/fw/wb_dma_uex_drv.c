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
		if (drv->core.status[i] == 1) {
			// Check this channel's CSR
			uint32_t csr = WB_DMA_READ_CH_CSR((&drv->core), i);

			if ((csr & 1) == 0) {
				// Transfer is done
				uex_mutex_lock(&drv->xfer_mutex[i]);
				drv->core.status[i] = 0;
				uex_cond_signal(&drv->xfer_cond[i]);
				uex_mutex_unlock(&drv->xfer_mutex[i]);
			}
		}
	}
}

void wb_dma_uex_drv_init(
		wb_dma_uex_drv_t		*drv,
		uint32_t				base,
		void					*user_data) {
	uint32_t i;
	wb_dma_drv_init(&drv->core, base, 1, user_data);

	for (i=0; i<31; i++) {
		uex_mutex_init(&drv->busy_mutex[i]);
		uex_mutex_init(&drv->xfer_mutex[i]);
		uex_cond_init(&drv->xfer_cond[i]);
	}

	uex_set_irq_handler(uex_get_irq((uint32_t *)base), &wb_dma_uex_irq, drv);
}

void wb_dma_uex_drv_single_xfer(
		wb_dma_uex_drv_t		*drv,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				inc_src,
		uint32_t				dest,
		uint32_t				inc_dst,
		uint32_t				sz) {
	uex_mutex_lock(&drv->busy_mutex[channel]);
	// First, use the underlying driver routine to program the channel

	wb_dma_drv_init_single_xfer(&drv->core, channel,
			src, inc_src, dest, inc_dst, sz);

	// Wait for completion
	uex_mutex_lock(&drv->xfer_mutex[channel]);
	uex_cond_wait(&drv->xfer_cond[channel], &drv->xfer_mutex[channel]);
	uex_mutex_unlock(&drv->xfer_mutex[channel]);

	uex_mutex_unlock(&drv->busy_mutex[channel]);
}

