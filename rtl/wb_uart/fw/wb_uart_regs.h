/****************************************************************************
 * wb_uart_regs.h
 ****************************************************************************/
#ifndef INCLUDED_WB_UART_REGS_H
#define INCLUDED_WB_UART_REGS_H
#include <stdint.h>

typedef struct wb_uart_regs_s {
	union {
		uint32_t		rbr;
		uint32_t		thr;
		uint32_t		dlb1;
	};

	union {
		uint32_t		ier;
		uint32_t		dlb2;
	};

	union {
		uint32_t			iir;
		uint32_t			fcr;
	};
	uint32_t			lcr;
	uint32_t			mcr;
	uint32_t			lsr;
	uint32_t			msr;
} wb_uart_regs_t;


#endif /* INCLUDED_WB_UART_REGS_H */
