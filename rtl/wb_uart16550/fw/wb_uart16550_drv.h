
#ifndef INCLUDED_WB_UART16550_DRV_H
#define INCLUDED_WB_UART16550_DRV_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) || defined(__CYGWIN__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

struct wb_uart16550_drv_s;

typedef struct wb_uart16550_drv_s {
	uint32_t			base;
	uint8_t

} wb_uart16550_drv_t;

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_WB_UART16550_DRV_H */
