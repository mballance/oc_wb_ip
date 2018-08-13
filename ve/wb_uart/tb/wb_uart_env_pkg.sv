
`include "uvm_macros.svh"

package wb_uart_env_pkg;
	import uvm_pkg::*;
	import uvmdev_pkg::*;
	import wb_master_agent_pkg::*;
	import event_agent_pkg::*;
	import wb_uart_regs_pkg::*;
	import wb_uart_dev_pkg::*;
	import uart_serial_agent_pkg::*;
	import uart_agent_dev_pkg::*;

	`include "wb_uart_isr.svh"
	`include "wb_uart_env.svh"
	
endpackage
