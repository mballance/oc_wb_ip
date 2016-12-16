
#include "wb_dma_drv.h"
#include <stdlib.h>

static uint32_t			drvId = 0;
static wb_dma_drv_t		drvArr[256];

EXPORT int _wb_dma_drv_init(
		uint32_t			*drv_id,
		uint32_t			base,
		uint32_t			irq_en,
		void				*user_data) {
	*drv_id = drvId;
	drvId++;
	wb_dma_drv_t *drv = &drvArr[*drv_id];
	wb_dma_drv_init(drv, base, irq_en, user_data);
	return 0;
}

EXPORT int _wb_dma_drv_init_single_xfer(
		uint32_t			drv_id,
		uint32_t			chan,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			num_words) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	wb_dma_drv_init_single_xfer(drv, chan, src, inc_src, dst, inc_dst, num_words);
	return 0;
}

EXPORT int _wb_dma_drv_init_linklist_desc(
		uint32_t			drv_id,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz,
		uint32_t			desc,
		uint32_t			desc_n) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	wb_dma_drv_ll_t *desc_p = (wb_dma_drv_ll_t *)((uint64_t)desc);
	wb_dma_drv_ll_t *desc_n_p = (wb_dma_drv_ll_t *)((uint64_t)desc_n);
	wb_dma_drv_init_linklist_desc(drv, src, inc_src,
			dst, inc_dst, sz, desc_p, desc_n_p);
	return 0;
}

EXPORT int _wb_dma_drv_init_linklist_xfer(
		uint32_t			drv_id,
		uint32_t			chan,
		uint32_t			desc) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	wb_dma_drv_ll_t *desc_p = (wb_dma_drv_ll_t *)((uint64_t)desc);

	wb_dma_drv_init_linklist_xfer(drv, chan, desc_p);
	return 0;
}

EXPORT int _wb_dma_drv_check_status(
		uint32_t			drv_id,
		int32_t				chan,
		uint32_t			*status) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	*status = wb_dma_drv_check_status(drv, chan);
	return 0;
}

EXPORT int _wb_dma_drv_poll(
		uint32_t		drv_id,
		uint32_t		*n_done) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	*n_done = wb_dma_drv_poll(drv);
	return 0;
}

