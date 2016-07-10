

#include "wb_uart16550_drv.h"
#include <stdlib.h>

static uint32_t					drvId = 0;
static wb_uart16550_drv_t		drvArr[256];


EXPORT int _wb_uart16550_drv_init(
		uint32_t			*drv_h,
		uint32_t			base,
		uint16_t			divisor) {
	wb_uart16550_drv_t *drv;

	*drv_h = drvId;
	drvId++;
	drv = &drvArr[*drv_h];

	wb_uart16550_drv_init(drv, base, divisor);

	return 0;
}

EXPORT int _wb_uart16550_drv_write(
		uint32_t			drv_h,
		uint8_t				*data,
		uint32_t			sz,
		uint32_t			*ret) {
	wb_uart16550_drv_t *drv = &drvArr[drv_h];
	*ret = wb_uart16550_drv_write(drv, data, sz);

	return 0;
}

EXPORT int _wb_uart16550_drv_read(
		uint32_t			drv_h,
		uint8_t				*data,
		uint32_t			sz,
		uint32_t			*ret) {
	wb_uart16550_drv_t *drv = &drvArr[drv_h];
	*ret = wb_uart16550_drv_read(drv, data, sz);

	return 0;
}

