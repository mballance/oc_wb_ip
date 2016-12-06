/****************************************************************************
 * wb_dma_tb.sv
 ****************************************************************************/

/**
 * Module: wb_dma_tb
 * 
 * TODO: Add module documentation
 */
`include "uvm_macros.svh"
module wb_dma_tb;
	import uvm_pkg::*;
	import wb_dma_tests_pkg::*;
	
	parameter int WB_ADDR_WIDTH=32;
	
	wb_if #( .WB_ADDR_WIDTH(WB_ADDR_WIDTH ) ) bfm2s0 ();
	wb_if #( .WB_ADDR_WIDTH(WB_ADDR_WIDTH ) ) stub2s1 ();
	
	wb_if #( .WB_ADDR_WIDTH(WB_ADDR_WIDTH ) ) m02bfm ();
	wb_if #( .WB_ADDR_WIDTH(WB_ADDR_WIDTH ) ) m12bfm ();
	
	wb_master_stub u_s1stub (.m (stub2s1.master));
	
	wire				inta_o;
	wire				intb_o;
	wire[30:0]			dma_req_i = '{0};
	wire[30:0]			dma_nd_i = '{0};
	wire[30:0]			dma_ack_o;
	wire[30:0]			dma_rest_i = '{0};
	
	reg					clk;
	reg					rst_i;
	
	initial begin
		rst_i <= 1;
		repeat(100) begin
			clk <= 0;
			#10ns;
			clk <= 1;
			#10ns;
		end
		rst_i <= 0;
		forever begin
			clk <= 0;
			#10ns;
			clk <= 1;
			#10ns;
		end
	end
	
	wb_dma_w u_dma (
		.clk         (clk           ), 
		.rst_i       (rst_i         ), 
		.wb0s        (bfm2s0.slave  ), 
		.wb0m        (m02bfm.master ), 
		.wb1s        (stub2s1.slave ), 
		.wb1m        (m12bfm.master ), 
		.dma_req_i   (dma_req_i     ), 
		.dma_nd_i    (dma_nd_i      ), 
		.dma_ack_o   (dma_ack_o     ), 
		.dma_rest_i  (dma_rest_i    ), 
		.inta_o      (inta_o        ), 
		.intb_o      (intb_o        ));
	
	initial begin
		run_test();
	end

endmodule

