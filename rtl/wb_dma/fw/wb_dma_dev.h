/****************************************************************************
 * wb_dma_uex_drv.h
 ****************************************************************************/
#ifndef INCLUDED_WB_DMA_DEV_H
#define INCLUDED_WB_DMA_DEV_H
#include "uex.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct wb_dma_channel_regs_s {
	uint32_t				csr;
	uint32_t				size;
	uint32_t				src;
	uint32_t				src_msk;
	uint32_t				dst;
	uint32_t				dst_msk;
	uint32_t				desc;
	uint32_t				swptr;
} wb_dma_channel_regs_t;

typedef struct wb_dma_regs_s {
	uint32_t				csr;
	uint32_t				int_msk_a;
	uint32_t				int_msk_b;
	uint32_t				int_src_a;
	uint32_t				int_src_b;
	uint32_t				pad[3]; // Channels start at 0x20
	wb_dma_channel_regs_t	channels[8];
} wb_dma_regs_t;

typedef struct wb_dma_dev_s {
	uex_dev_t				base;
	wb_dma_regs_t			*regs;
	uint32_t				status[31];

	uex_mutex_t				busy_mutex[31];
	uex_mutex_t				xfer_mutex[31];
	uex_cond_t				xfer_cond[31];
} wb_dma_dev_t;

void wb_dma_dev_init(uex_dev_t *devh);

void wb_dma_dev_single_xfer(
		uint32_t				devid,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				inc_src,
		uint32_t				dest,
		uint32_t				inc_dst,
		uint32_t				sz);

#define WB_DMA_DEV_STATIC_INIT(__name, __base_addr) {\
	.base = UEX_DEV_STATIC_INIT(__name, __base_addr, wb_dma_dev_init) \
}

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_DMA_DEV_H */
