
#include "wb_uart16550_drv.h"
#include <string.h>
#include <stdio.h>

#ifdef USE_SV_BFMS_RW_API
#include "sv_bfms_rw_api_if.h"
#define WB_UART16550_WRITE8(drv, addr, data) sv_bfms_write8((drv), (uint32_t)(addr), (data))
#define WB_UART16550_READ8(drv, addr)        sv_bfms_read8((drv), (uint32_t)(addr))
#else
#define WB_UART16550_WRITE8(drv, addr, data) *((volatile uint8_t *)(addr)) = (data)
#define WB_UART16550_READ8(drv, addr) *((volatile uint8_t *)(addr))
#endif

// Data is ready
#define WB_UART16550_LSR_DR (1 << 0)

// Tx FIFO is empty
#define WB_UART16550_LSR_TFE (1 << 5)
// THR is emtpy
#define WB_UART16550_LSR_THE (1 << 6)

#define WB_UART16550_WRITE_THR(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 0), data)

#define WB_UART16550_READ_RB(drv) \
	WB_UART16550_READ8(drv, ((drv)->base + 0))

#define WB_UART16550_WRITE_IER(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 1), data)

#define WB_UART16550_READ_IER(drv) \
	WB_UART16550_READ8(drv, ((drv)->base + 2))

#define WB_UART16550_WRITE_FCR(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 2), data)

#define WB_UART16550_READ_IIR(drv) \
	WB_UART16550_READ8(drv, ((drv)->base + 2))

#define WB_UART16550_WRITE_LCR(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 3), data)

#define WB_UART16550_READ_LCR(drv) \
	WB_UART16550_READ8(drv, ((drv)->base + 3))

#define WB_UART16550_READ_LSR(drv) \
	WB_UART16550_READ8(drv, ((drv)->base + 5))

#define WB_UART16550_WRITE_DL1(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 0), data)

#define WB_UART16550_WRITE_DL2(drv, data) \
	WB_UART16550_WRITE8(drv, ((drv)->base + 1), data)

void wb_uart16550_drv_init(
		wb_uart16550_drv_t		*drv,
		uint32_t				base,
		uint16_t				divisor) {
	memset(drv, 0, sizeof(wb_uart16550_drv_t));
	drv->base = base;

	WB_UART16550_WRITE_FCR(drv, 0xC3); // Clear FIFOs

	// Enable access to counter registers
	WB_UART16550_WRITE_LCR(drv,
			(WB_UART16550_READ_LCR(drv) | (0x80)));

	WB_UART16550_WRITE_DL2(drv, (divisor >> 8));
	WB_UART16550_WRITE_DL1(drv, (divisor & 0xFF));

	// Disable access to the counter registers
	WB_UART16550_WRITE_LCR(drv,
			(WB_UART16550_READ_LCR(drv) & (0x7F)));

	// Configure the UART paramters
	WB_UART16550_WRITE_LCR(drv, 0x03); // N81
}

void wb_uart16550_drv_setflags(
		wb_uart16550_drv_t		*drv,
		uint32_t				flags) {
	drv->flags |= flags;
}

void wb_uart16550_drv_clrflags(
		wb_uart16550_drv_t		*drv,
		uint32_t				flags) {
	drv->flags &= ~flags;
}

int32_t wb_uart16550_drv_write(
		wb_uart16550_drv_t		*drv,
		uint8_t					*data,
		uint32_t				sz) {
	uint32_t idx=0;
	uint8_t lsr;

	// First fill up the Tx fifo
	do {
		while (idx < sz && drv->est_tx_fill < WB_UART16550_FIFO_SZ) {
			WB_UART16550_WRITE_THR(drv, data[idx++]);
			drv->est_tx_fill++;
		}

		// If the THR register is empty, then so is the FIFO
		if (idx < sz) {
			lsr = WB_UART16550_READ_LSR(drv);

			if ((lsr & WB_UART16550_LSR_TFE) != 0) {
				fprintf(stdout, "FIFO empty\n");
				drv->est_tx_fill = 0;
			}
		}
	} while (idx < sz &&
			// Keep going if in nonblock mode
			(drv->est_tx_fill < WB_UART16550_FIFO_SZ || !(drv->flags & WB_UART16550_NONBLOCK)));

	if (drv->flags & WB_UART16550_INTMODE) {
		// TODO: fill tx buffer if in INT mode and there's leftover data
	}

	// Return the bytes we were able to write
	return idx;
}

int32_t wb_uart16550_drv_read(
		wb_uart16550_drv_t			*drv,
		uint8_t						*data,
		uint32_t					sz) {
	uint32_t idx=0;
	uint8_t lsr;

	if (drv->flags & WB_UART16550_INTMODE) {
		// TODO: first fill from local receive buffer
	}

	do {
		lsr = WB_UART16550_READ_LSR(drv);

		if ((lsr & WB_UART16550_LSR_DR) != 0) {
			data[idx++] = WB_UART16550_READ_RB(drv);
			fprintf(stdout, "data[%d] = 0x%02x\n", idx-1, data[idx-1]);
		}
		// Keep reading until:
		// - reach end of buffer
		// - reach end of data
		// - read something
		// - OR: in non-blocking mode
	} while ((idx < sz && (lsr & WB_UART16550_LSR_DR)) ||
			(!(drv->flags & WB_UART16550_NONBLOCK) && idx == 0));

	return idx;
}
