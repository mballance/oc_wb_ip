/****************************************************************************
 * wb_periph_subsys_tb.sv
 ****************************************************************************/

/**
 * Module: wb_periph_subsys_tb_hvl
 * 
 * TODO: Add module documentation
 */
`ifdef HAVE_UVM
`include "uvm_macros.svh"
`endif
module wb_periph_subsys_tb_hvl;
`ifdef HAVE_UVM
	import uvm_pkg::*;
`endif
	
	initial begin
		run_test();
	end

endmodule

