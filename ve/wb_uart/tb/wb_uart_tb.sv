/****************************************************************************
 * wb_uart_tb.sv
 ****************************************************************************/

/**
 * Module: wb_uart_tb
 * 
 * TODO: Add module documentation
 */
`ifdef HAVE_UVM
`include "uvm_macros.svh"
`endif
module wb_uart_tb(input clk);
`ifdef HAVE_UVM
	import uvm_pkg::*;
	import wb_uart_tests_pkg::*;
`endif
	
`ifdef HAVE_HDL_CLKGEN
		reg clk_r = 0;
		initial begin
			forever begin
				#10ns;
				clk_r <= ~clk_r;
			end
		end
		assign clk = clk_r;
`endif
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
	reg rst = 1;
	reg[7:0] rst_cnt = 0;

	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rst <= 0;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	wb_if #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_bfm2uart ();
	
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_wb_bfm (
		.clk            (clk              ), 
		.rstn           (rstn             ), 
		.master         (u_bfm2uart.master));

	wb_uart u_uart (
		.clk        (clk             ), 
		.rstn       (~rst            ), 
		.s          (u_bfm2uart.slave), 
		.int_o      (int_o     ), 
		.stx_pad_o  (stx_pad_o ), 
		.srx_pad_i  (srx_pad_i ), 
		.rts_pad_o  (rts_pad_o ), 
		.cts_pad_i  (cts_pad_i ), 
		.dtr_pad_o  (dtr_pad_o ), 
		.dsr_pad_i  (dsr_pad_i ), 
		.ri_pad_i   (ri_pad_i  ), 
		.dcd_pad_i  (dcd_pad_i ));

`ifdef HAVE_UVM
	initial begin
		run_test();
	end
	`endif

endmodule

