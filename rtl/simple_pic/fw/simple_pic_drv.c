/****************************************************************************
 * simple_pic_drv.h
 ****************************************************************************/
#include "simple_pic_drv.h"
#include <string.h>

#ifdef USE_SV_BFMS_RW_API
#include "sv_bfms_rw_api_if.h"
#define SIMPLE_PIC_WRITE32(drv, addr, data) sv_bfms_write32((drv), (uint32_t)(addr), (data))
#define SIMPLE_PIC_READ32(drv, addr)        sv_bfms_read32((drv), (uint32_t)(addr));
#else
#define SIMPLE_PIC_WRITE32(drv, addr, data) *((volatile uint32_t *)(addr)) = (data)
#define SIMPLE_PIC_READ32(drv, addr) *((volatile uint32_t *)(addr))
#endif

typedef enum {
	EdgeEnable = 0x0000,
	Polarity   = 0x0004,
	Mask       = 0x0008,
	Pending    = 0x000C
};

void simple_pic_drv_init(
		simple_pic_drv_t		*drv,
		uint32_t				base) {
	memset(drv, 0, sizeof(simple_pic_drv_t));

	SIMPLE_PIC_WRITE32(drv, drv->base+EdgeEnable, 0); // All level triggered
	SIMPLE_PIC_WRITE32(drv, drv->base+Polarity, 0xFFFFFFFF); // All active high
	SIMPLE_PIC_WRITE32(drv, drv->base+Mask, 0); // All are initially masked
	SIMPLE_PIC_WRITE32(drv, drv->base+Pending, 0xFFFFFFFF); // Clear any pending
}

void simple_pic_drv_set_en(
		simple_pic_drv_t		*drv,
		uint32_t				irq,
		uint32_t				en) {
	uint32_t mask = SIMPLE_PIC_READ32(drv, drv->base+Mask);

	if (en) {
		mask |= (1 << irq);
	} else {
		mask &= ~(1 << irq);
	}

	SIMPLE_PIC_WRITE32(drv, drv->base+Mask, mask);
}

void simple_pic_drv_ack(
		simple_pic_drv_t		*drv,
		uint32_t				irq) {
	uint32_t ack = (1 << irq);

	SIMPLE_PIC_WRITE32(drv, drv->base+Pending, ack);
}
