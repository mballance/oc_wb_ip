/****************************************************************************
 * wb_simple_pic_dev.h
 ****************************************************************************/
#ifndef INCLUDED_WB_SIMPLE_PIC_DEV_H
#define INCLUDED_WB_SIMPLE_PIC_DEV_H
#include <stdint.h>
#include "uex.h"

#ifdef __cplusplus
extern "C" {
#endif

struct wb_simple_pic_regs_s;

typedef struct wb_simple_pic_dev_s {
	uex_dev_t					base;
	struct wb_simple_pic_regs_s	*regs;

} wb_simple_pic_dev_t;

#define WB_SIMPLE_PIC_STATIC_INIT(__name, __base_addr) { \
	.base = UEX_DEV_STATIC_INIT(__name, __base_addr, wb_simple_pic_dev_init) \
}

void wb_simple_pic_dev_init(uex_dev_t *devh);

void wb_simple_pic_dev_en_irq(
		uint32_t				devid,
		uint32_t				irq,
		uint32_t				en);

// Read pending
uint32_t wb_simple_pic_dev_get_pending(
		uint32_t				devid);

// Acknowledges an interrupt
void wb_simple_pic_dev_clr_pending(
		uint32_t				devid,
		uint32_t				irq);


#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_SIMPLE_PIC_DEV_H */
