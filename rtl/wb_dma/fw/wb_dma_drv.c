
#include "wb_dma_drv.h"

#ifndef WB_DMA_WRITE32
#define WB_DMA_WRITE32(addr, data) *((volatile uint32_t *)(addr)) = (data)
#endif

#ifndef WB_DMA_READ32
#define WB_DMA_READ32(addr) *((volatile uint32_t *)(addr))
#endif


