/****************************************************************************
 * simple_pic_drv.h
 ****************************************************************************/
#ifndef INCLUDED_SIMPLE_PIC_DRV_H
#define INCLUDED_SIMPLE_PIC_DRV_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

typedef struct simple_pic_drv_s {
	uint32_t			base;

} simple_pic_drv_t;

EXPORT void simple_pic_drv_init(
		simple_pic_drv_t		*drv,
		uint32_t				base);

EXPORT void simple_pic_drv_set_en(
		simple_pic_drv_t		*drv,
		uint32_t				irq,
		uint32_t				en);

// Acknowledges an interrupt
EXPORT void simple_pic_drv_ack(
		simple_pic_drv_t		*drv,
		uint32_t				irq);

#undef EXPORT

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_SIMPLE_PIC_DRV_H */
