
#include "wb_dma_drv.h"
#include <stdlib.h>

static uint32_t			drvId = 0;
static wb_dma_drv_t		drvArr[256];

EXPORT int _wb_dma_drv_init(
		uint32_t			*drv_id,
		uint32_t			base,
		void				*user_data) {
	*drv_id = drvId;
	drvId++;
	wb_dma_drv_t *drv = &drvArr[*drv_id];
	wb_dma_drv_init(drv, base, user_data);
	return 0;
}

EXPORT int _wb_dma_drv_begin_xfer(
		uint32_t			drv_id,
		uint32_t			src,
		uint32_t			dst,
		uint32_t			num_words,
		int32_t				*chan) {
	wb_dma_drv_t *drv = &drvArr[drv_id];
	*chan = wb_dma_drv_begin_xfer(
			drv, src, dst, num_words, 0);
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

