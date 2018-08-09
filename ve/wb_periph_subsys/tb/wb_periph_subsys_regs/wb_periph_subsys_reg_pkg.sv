/****************************************************************************
 * wb_periph_subsys_reg_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"


/**
 * Package: wb_periph_subsys_reg_pkg
 * 
 * TODO: Add package documentation
 */
package wb_periph_subsys_reg_pkg;
	import uvm_pkg::*;
	import wb_simple_pic_reg_pkg::*;
	import wb_dma_regs_pkg::*;
	import wb_uart_regs_pkg::*;

	`include "wb_periph_subsys_regblk.svh"

endpackage


