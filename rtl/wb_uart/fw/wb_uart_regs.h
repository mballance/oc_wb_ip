/****************************************************************************
 * wb_uart_regs.h
 ****************************************************************************/
#ifndef INCLUDED_WB_UART_REGS_H
#define INCLUDED_WB_UART_REGS_H
#include <stdint.h>

typedef struct wb_uart_regs_s {
	union {
		uint8_t		rbr;
		uint8_t		thr;
		uint8_t		dlb1;
	};

	union {
		uint8_t		ier;
		uint8_t		dlb2;
	};

	union {
		uint8_t			iir;
		uint8_t			fcr;
	};
	uint8_t			lcr;
	uint8_t			mcr;
	uint8_t			lsr;
	uint8_t			msr;
} wb_uart_regs_t;


#endif /* INCLUDED_WB_UART_REGS_H */
