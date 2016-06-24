
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

/**
 * Begins a transfer. Returns the channel
 * carrying out the transfer, or -1 if setup failed
 */
EXPORT int32_t wb_dma_drv_begin_xfer(
		wb_dma_drv_t		*drv,
		uint32_t			src,
		uint32_t			dst,
		uint32_t			num_words,
		wb_dma_drv_done_f	done_func
		);

//EXPORT int32_t wb_dma_drv_init_ll_xfer(
//		wb_dma_drv_t		*drv,
//		uint32_t
//		);

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
