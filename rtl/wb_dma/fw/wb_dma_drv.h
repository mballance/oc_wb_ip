
#ifndef INCLUDED_WB_DMA_DRV_H
#define INCLUDED_WB_DMA_DRV_H
#include <stdint.h>

typedef void (*wb_dma_drv_done_f)(
		wb_dma_drv_t		*drv,
		uint32_t			chan);

typedef struct wb_dma_drv_s {
	void					*base_addr;
	wb_dma_drv_done_f		done_func_list[31];
	uint32_t				active[31];
	void					*user_data;
} wb_dma_drv_t;

/**
 * Initializes the DMA driver
 */
void wb_dma_drv_init(
		wb_dma_drv_t 	*drv,
		void			*base,
		void			*user_data);

/**
 * Begins a transfer. Returns the channel
 * carrying out the transfer, or -1 if setup failed
 */
int32_t wb_dma_drv_begin_xfer(
		wb_dma_drv_t		*drv,
		void				*src,
		void				*dst,
		uint32_t			num_words,
		wb_dma_drv_done_f	done_func
		);

/**
 * Checks whether the transfer on a specific channel
 * is complete.
 */
uint32_t wb_dma_drv_check_complete(
		wb_dma_drv_t		*drv,
		int32_t				chan
		);

/**
 * Polls all active channels for completion and
 * performs notifications (if requested)
 */
uint32_t wb_dma_drv_poll(
		wb_dma_drv_t		*drv
		);


#endif /* INCLUDED_WB_DMA_DRV_H */
