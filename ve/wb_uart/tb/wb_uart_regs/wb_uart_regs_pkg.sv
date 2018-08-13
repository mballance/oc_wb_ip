/****************************************************************************
 * wb_uart_regs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

/**
 * Package: wb_uart_regs_pkg
 * 
 * TODO: Add package documentation
 */
package wb_uart_regs_pkg;
	import uvm_pkg::*;
	
	`include "uart_rb_thr_reg.svh"
	`include "uart_ie_reg.svh"
	`include "uart_ii_reg.svh"
	`include "uart_lc_reg.svh"

	`include "wb_uart_reg_block.svh"

endpackage


