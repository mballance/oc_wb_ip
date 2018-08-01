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
	import wb_master_agent_pkg::*;
	import uart_serial_agent_pkg::*;
	import event_agent_pkg::*;
`endif

`ifdef HAVE_UVM
	initial begin
		typedef wb_master_config #(32, 32)	wb_master_config_t;
		typedef event_config #(1)			event_config_t;
		
		automatic wb_master_config_t		wb_master_cfg = wb_master_config_t::type_id::create();
		automatic uart_serial_config		uart_cfg = uart_serial_config::type_id::create();
		automatic event_config_t			event_cfg = event_config_t::type_id::create();
		
		wb_master_cfg.vif = wb_periph_subsys_tb_hdl.u_wb_bfm.u_core;
		uart_cfg.vif      = wb_periph_subsys_tb_hdl.u_uart0_bfm.u_core;
//		event_cfg.vif     = wb_periph_subsys_tb_hdl.u_

		uvm_config_db #(wb_master_config_t)::set(uvm_top, "", 
				wb_master_config_t::report_id, wb_master_cfg);
		uvm_config_db #(uart_serial_config)::set(uvm_top, "",
				uart_serial_config::report_id, uart_cfg);

		run_test();
	end
`endif

endmodule

