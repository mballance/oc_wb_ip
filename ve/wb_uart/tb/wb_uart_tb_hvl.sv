/****************************************************************************
 * wb_uart_tb_hvl.sv
 ****************************************************************************/

/**
 * Module: wb_uart_tb_hvl
 * 
 * TODO: Add module documentation
 */
`ifdef HAVE_UVM
`include "uvm_macros.svh"
`endif
module wb_uart_tb_hvl;
`ifdef HAVE_UVM
	import uvm_pkg::*;
	import wb_master_agent_pkg::*;
	import event_agent_pkg::*;
	import uart_serial_agent_pkg::*;
`endif
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
`ifdef HAVE_UVM
	initial begin
		typedef wb_master_config #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_config_t;
		automatic wb_master_config_t wb_bfm_cfg = wb_master_config_t::type_id::create();
		automatic event_config irq_cfg = event_config::type_id::create();
		automatic event_config handshake_cfg = event_config::type_id::create();
		automatic uart_serial_config uart_cfg = uart_serial_config::type_id::create();
		
		wb_bfm_cfg.vif = wb_uart_tb_hdl.u_wb_bfm.u_core;
		uvm_config_db #(wb_master_config_t)::set(uvm_top, "", 
				wb_master_config_t::report_id, wb_bfm_cfg);
		
		irq_cfg.vif = wb_uart_tb_hdl.u_irq_bfm.u_core;
		uvm_config_db #(event_config)::set(uvm_top, "*m_irq_agent*",
				event_config::report_id, irq_cfg);
		
		handshake_cfg.vif = wb_uart_tb_hdl.u_handshake_bfm.u_core;
		uvm_config_db #(event_config)::set(uvm_top, "*m_handshake_agent*",
				event_config::report_id, handshake_cfg);
		
		uart_cfg.vif = wb_uart_tb_hdl.u_uart_bfm.u_core;
		uvm_config_db #(uart_serial_config)::set(uvm_top, "*m_serial_agent*",
				uart_serial_config::report_id, uart_cfg);
			
		
		run_test();
	end
`endif

endmodule

