/****************************************************************************
 * wb_uart16550_tb.sv
 ****************************************************************************/

/**
 * Module: wb_uart16550_tb
 * 
 * TODO: Add module documentation
 */
`include "uvm_macros.svh"
module wb_uart16550_tb;
	import uvm_pkg::*;
	import wb_uart16550_tests_pkg::*;
	import wb_master_agent_pkg::*;
	import uart_serial_agent_pkg::*;
	
	reg clk_i = 0;
	reg rstn = 0;
	reg[7:0] rst_cnt = 0;
	
	initial begin
		forever begin
			clk_i <= 0;
			#20ns;
			clk_i <= 1;
			#20ns;
		
			if (rst_cnt == 100) begin
				rstn <= 1;
			end else begin
				rst_cnt <= rst_cnt + 1;
				rstn <= 0;
			end
		end
	end
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) bfm2uart (
		);
	
	wire int_o;
	wire uart_tx_o, uart_rx_i;
	wire cts_pad_i, dsr_pad_i, ri_pad_i, dcd_pad_i;
	
	wire bfm_uart_rx_i, bfm_uart_tx_o;
	
	assign cts_pad_i = 1;
	assign dsr_pad_i = 1;
	assign ri_pad_i = 0;
	assign dcd_pad_i = 1;
	
	assign bfm_uart_rx_i = uart_tx_o;
	assign uart_rx_i = bfm_uart_tx_o;

	wb_uart16550_shell #(
		.u_type     ("RTL"    )
		) u_dut (
		.clk_i      (clk_i          ), 
		.rst_i      (!rstn          ), 
		.s          (bfm2uart.slave ), 
		.int_o      (int_o          ), 
		.stx_pad_o  (uart_tx_o      ), 
		.srx_pad_i  (uart_rx_i      ), 
		.rts_pad_o  (rts_pad_o      ), 
		.cts_pad_i  (cts_pad_i      ), 
		.dtr_pad_o  (dtr_pad_o      ), 
		.dsr_pad_i  (dsr_pad_i      ), 
		.ri_pad_i   (ri_pad_i       ), 
		.dcd_pad_i  (dcd_pad_i      ));
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) u_wb_bfm (
		.clk            (clk_i          ), 
		.rstn           (rstn           ), 
		.master         (bfm2uart.master));
	
	uart_serial_bfm u_uart_bfm (
		.clk_i      (clk_i         ), 
		.rstn_i     (rstn          ), 
		.stx_pad_o  (bfm_uart_tx_o ), 
		.srx_pad_i  (bfm_uart_rx_i ), 
		.rts_pad_o  (bfm_rts_pad_o ), 
		.cts_pad_i  (bfm_cts_pad_i ), 
		.dtr_pad_o  (bfm_dtr_pad_o ), 
		.dsr_pad_i  (bfm_dsr_pad_i ), 
		.ri_pad_i   (bfm_ri_pad_i  ), 
		.dcd_pad_i  (bfm_dcd_pad_i ));

	typedef wb_master_config #(32,32) wb_cfg_t;
	
	initial begin
		automatic wb_cfg_t wb_cfg = wb_cfg_t::type_id::create("wb_cfg");
		automatic uart_serial_config serial_cfg = uart_serial_config::type_id::create("serial_cfg");
		
		wb_cfg.vif = u_wb_bfm;
		uvm_config_db #(wb_cfg_t)::set(uvm_top, "*wb_master*",
				wb_cfg_t::report_id, wb_cfg);
		
		serial_cfg.vif = u_uart_bfm;
		serial_cfg.vif_path = $psprintf("%m.u_uart_bfm");
		uvm_config_db #(uart_serial_config)::set(uvm_top, "*uart_agent*",
				uart_serial_config::report_id, serial_cfg);
		
		run_test();
	end

endmodule

