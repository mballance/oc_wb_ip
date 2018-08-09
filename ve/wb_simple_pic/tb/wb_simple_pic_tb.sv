/****************************************************************************
 * wb_simple_pic_tb.sv
 ****************************************************************************/

/**
 * Module: wb_simple_pic_tb
 * 
 * TODO: Add module documentation
 */
`include "uvm_macros.svh"
module wb_simple_pic_tb;
	import uvm_pkg::*;
	import wb_simple_pic_tests_pkg::*;
	
	initial begin
		run_test();
	end

endmodule

