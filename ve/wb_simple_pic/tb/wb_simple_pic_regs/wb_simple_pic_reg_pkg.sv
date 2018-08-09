/****************************************************************************
 * wb_simple_pic_reg_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

/**
 * Package: wb_simple_pic_reg_pkg
 * 
 * TODO: Add package documentation
 */
package wb_simple_pic_reg_pkg;
	import uvm_pkg::*;
	
	`include "edge_enable_reg.svh"
	`include "mask_reg.svh"
	`include "pending_reg.svh"
	`include "polarity_reg.svh"
	`include "wb_simple_pic_regs.svh"


endpackage


