
#ifndef INCLUDED_WB_DMA_DRV_H
#define INCLUDED_WB_DMA_DRV_H
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

struct wb_dma_drv_s;

typedef void (*wb_dma_drv_done_f)(
		struct wb_dma_drv_s	*drv,
		uint32_t			chan);

typedef struct wb_dma_drv_ll_s {
	uint32_t			csr;
	uint32_t			src;
	uint32_t			dst;
	uint32_t			nxt;
} wb_dma_drv_ll_t;

typedef struct wb_dma_drv_s {
	uint32_t				base;
	wb_dma_drv_done_f		done_func_list[31];
	uint32_t				status[31];
	void					*user_data;
} wb_dma_drv_t;

/**
 * Initializes the DMA driver
 */
EXPORT void wb_dma_drv_init(
		wb_dma_drv_t 	*drv,
		uint32_t		 base,
		uint32_t         irq_en,
		void			*user_data);

EXPORT void wb_dma_drv_set_channel_priority(
		wb_dma_drv_t		*drv,
		uint32_t			channel,
		uint8_t				pri);

/**
 * Initializes a channel to perform a single transfer
 */
EXPORT void wb_dma_drv_init_single_xfer(
		wb_dma_drv_t		*drv,
		uint32_t			channel,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz
		);

/**
 * Initializes a linked-list descriptor. The caller
 * is responsible for allocating the memory for
 * desc and desc_n
 */
EXPORT void wb_dma_drv_init_linklist_desc(
		wb_dma_drv_t		*drv,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz,
		wb_dma_drv_ll_t		*desc,
		wb_dma_drv_ll_t		*desc_n);

/**
 * Initializes a channel to perform a linked-list transfer
 */
EXPORT void wb_dma_drv_init_linklist_xfer(
		wb_dma_drv_t		*drv,
		uint32_t			channel,
		wb_dma_drv_ll_t		*desc);

/**
 * Checks whether the status of a specific channel:
 * 0 - channel is inactive without errors
 * 1 - channel is active
 */
EXPORT uint32_t wb_dma_drv_check_status(
		wb_dma_drv_t		*drv,
		int32_t				chan
		);

/**
 * Polls all active channels for completion and
 * performs notifications (if requested)
 */
EXPORT uint32_t wb_dma_drv_poll(wb_dma_drv_t *drv);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_DMA_DRV_H */
