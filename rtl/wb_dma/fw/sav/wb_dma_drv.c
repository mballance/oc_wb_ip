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

#define WB_DMA_READ_CH_SZ(drv, ch) \
	WB_DMA_READ32(drv, ((drv)->base + 0x24 + (ch)*0x20))

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
		uint32_t		irq_en,
		void			*user_data) {
	uint32_t i;

	memset(drv, 0, sizeof(wb_dma_drv_t));
	drv->base = base;
	drv->user_data = user_data;

	// Route enabled channels to INTA
	if (irq_en) {
		WB_DMA_WRITE32(drv, drv->base+0x04, 0xFFFFFFFF);
		WB_DMA_WRITE32(drv, drv->base+0x0C, 0xFFFFFFFF);
	}

	for (i=0; i<31; i++) {
		// Enable for 256-byte chunks
		uint32_t sz_v = ((256/4) << 16);

		WB_DMA_WRITE_CH_SZ(drv, i, sz_v);

		// Configure mask
		WB_DMA_WRITE_CH_AM0(drv, i, 0xFFFFFFFC);
		WB_DMA_WRITE_CH_AM1(drv, i, 0xFFFFFFFC);
	}
}

void wb_dma_drv_init_single_xfer(
		wb_dma_drv_t		*drv,
		uint32_t			ch,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz
		) {
	uint32_t sz_v, csr;
	fprintf(stdout, "begin_xfer: drv=%p ch=%d\n", drv, ch);
	fflush(stdout);

	csr = WB_DMA_READ_CH_CSR(drv, ch);

	csr |= (1 << 18); // interrupt on done
	csr |= (1 << 17); // interrupt on error
	if (inc_src) {
		csr |= (1 << 4); // increment source
	} else {
		csr &= ~(1 << 4);
	}
	if (inc_dst) {
		csr |= (1 << 3); // increment destination
	} else {
		csr &= ~(1 << 3); // increment destination
	}

	csr |= (1 << 2); // use interface 0 for source
	csr |= (1 << 1); // use interface 1 for destination

	csr |= (1 << 0); // enable channel

	// Setup source and destination addresses
	WB_DMA_WRITE_CH_A0(drv, ch, src);
	WB_DMA_WRITE_CH_A1(drv, ch, dst);

	sz_v = WB_DMA_READ_CH_SZ(drv, ch);
	sz_v &= ~(0xFFF); // Clear tot_sz
	sz_v |= (sz & 0xFFF);
	WB_DMA_WRITE_CH_SZ(drv, ch, sz_v);

	// Start the transfer
	WB_DMA_WRITE_CH_CSR(drv, ch, csr);

	drv->status[ch] = 1;
}

void wb_dma_drv_init_linklist_desc(
		wb_dma_drv_t		*drv,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz,
		wb_dma_drv_ll_t		*desc,
		wb_dma_drv_ll_t		*desc_n
		) {

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
	uint32_t ch, mask=0;

	for (ch=0; ch<31; ch++) {
		if (drv->status[ch] == 1) {

			// Check whether it's actually done
			uint32_t csr = WB_DMA_READ_CH_CSR(drv, ch);

			fprintf(stdout, "csr=0x%08x\n", csr);
			fflush(stdout);

			if ((csr & 1) == 0) {
				// inactive
				if ((csr & (1 << 12)) != 0) {
					drv->status[ch] = 2; // Error (?)
				} else {
					drv->status[ch] = 0; // Done
				}
				mask |= (1 << ch);
			}
		}
	}

	return mask;
}



