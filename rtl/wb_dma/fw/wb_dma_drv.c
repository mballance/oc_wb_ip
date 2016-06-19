/****************************************************************************
 *
 ****************************************************************************/
#include "wb_dma_drv.h"
#include <string.h>
#include <stdio.h>

#ifdef USE_SV_BFMS_RW_API
#include "sv_bfms_rw_api_if.h"
#define WB_DMA_WRITE32(drv, addr, data) sv_bfms_write32((drv), (uint32_t)(addr), (data))
#define WB_DMA_READ32(drv, addr)        sv_bfms_read32((drv), (uint32_t)(addr));
#else
#define WB_DMA_WRITE32(drv, addr, data) *((volatile uint32_t *)(addr)) = (data)
#define WB_DMA_READ32(drv, addr) *((volatile uint32_t *)(addr))
#endif

#define WB_DMA_WRITE_CH_CSR(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x20 + (ch)*0x20), data)

#define WB_DMA_READ_CH_CSR(drv, ch) \
	WB_DMA_READ32(drv, ((drv)->base + 0x20 + (ch)*0x20))

#define WB_DMA_WRITE_CH_SZ(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x24 + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_A0(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x28 + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_AM0(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x2c + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_A1(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x30 + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_AM1(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x34 + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_DESC(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x38 + (ch)*0x20), data)

#define WB_DMA_WRITE_CH_SWPTR(drv, ch, data) \
	WB_DMA_WRITE32(drv, ((drv)->base + 0x3c + (ch)*0x20), data)


void wb_dma_drv_init(
		wb_dma_drv_t 	*drv,
		uint32_t		base,
		void			*user_data) {
	memset(drv, 0, sizeof(wb_dma_drv_t));
	drv->base = base;
	drv->user_data = user_data;
}

int32_t wb_dma_drv_begin_xfer(
		wb_dma_drv_t		*drv,
		uint32_t			src,
		uint32_t			dst,
		uint32_t			num_words,
		wb_dma_drv_done_f	done_func
		) {
	int32_t ch = -1;
	uint32_t i;


	// Select a channel
	for (i=0; i<31; i++) {
		if (drv->status[i] != 1) {
			ch = i;
			break;
		}
	}

	fprintf(stdout, "begin_xfer: drv=%p ch=%d\n", drv, ch);
	fflush(stdout);

	if (ch != -1) {
		uint32_t csr = WB_DMA_READ_CH_CSR(drv, ch);

		csr |= (1 << 4); // increment source
		csr |= (1 << 3); // increment destination
		csr |= (1 << 1); // use interface 1 for destination
		csr |= (1 << 0); // enable channel
		// Setup source and destination addresses
		WB_DMA_WRITE_CH_A0(drv, ch, src);
		WB_DMA_WRITE_CH_A1(drv, ch, dst);
		WB_DMA_WRITE_CH_SZ(drv, ch, num_words);

		// Start the transfer
		WB_DMA_WRITE_CH_CSR(drv, ch, csr);

		drv->status[ch] = 1;
	}

	return ch;
}

uint32_t wb_dma_drv_check_status(
		wb_dma_drv_t		*drv,
		int32_t				ch
		) {
	fprintf(stdout, "check_status: drv=%p ch=%d status=%d\n",
			drv, ch, drv->status[ch]);
	fflush(stdout);
	if (drv->status[ch] == 1) {
		// Check whether it's actually done
		uint32_t csr = WB_DMA_READ_CH_CSR(drv, ch);

		fprintf(stdout, "csr=0x%08x\n", csr);
		fflush(stdout);

		if ((csr & 1) == 0) {
			// inactive
			if ((csr & (1 << 12)) != 0) {
				drv->status[ch] = 2;
			} else {
				drv->status[ch] = 0;
			}
		}
	}

	return drv->status[ch];
}

uint32_t wb_dma_drv_poll(wb_dma_drv_t *drv) {
	uint32_t i, cnt=0;

	for (i=0; i<31; i++) {
		if (drv->status[i] == 1) {

			// TODO: Check whether the channel is actually complete

			if (/* TODO: is_done && */ drv->done_func_list[i]) {
				drv->done_func_list[i](drv, i);
				drv->done_func_list[i] = 0; // always null out
			}

			if (/* TODO: is_done */1) {
				cnt++;
			}
		}
	}

	return cnt;
}



