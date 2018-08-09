
`include "uvm_macros.svh"

package wb_periph_subsys_env_pkg;
	import uvm_pkg::*;
	import wb_master_agent_pkg::*;
	import uart_serial_agent_pkg::*;
	import event_agent_pkg::*;
	import wb_periph_subsys_reg_pkg::*;
	import sv_bfms_api_pkg::*;
	import wb_dma_dev_pkg::*;
	import wb_uart_dev_pkg::*;
	import wb_simple_pic_dev_pkg::*;
	import uvmdev_pkg::*;

	`include "wb_periph_subsys_isr.svh"
	`include "wb_periph_subsys_env.svh"
	
endpackage
