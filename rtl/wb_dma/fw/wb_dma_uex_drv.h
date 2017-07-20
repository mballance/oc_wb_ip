/****************************************************************************
 * wb_dma_uex_drv.h
 ****************************************************************************/
#ifndef INCLUDED_WB_DMA_UEX_DRV_H
#define INCLUDED_WB_DMA_UEX_DRV_H
#include "wb_dma_drv.h"
#include "uex.h"

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

typedef struct wb_dma_uex_drv_s {
	wb_dma_drv_t			core;

	uex_mutex_t				busy_mutex[31];
	uex_mutex_t				xfer_mutex[31];
	uex_cond_t				xfer_cond[31];
};

void wb_dma_uex_drv_init(
		wb_dma_uex_drv_t		*drv,
		uint32_t				base,
		void					*user_data);


void wb_dma_uex_drv_single_xfer(
		wb_dma_uex_drv_t		*drv,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				inc_src,
		uint32_t				dest,
		uint32_t				inc_dst,
		uint32_t				sz);


#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_DMA_UEX_DRV_H */
