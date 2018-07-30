

`include "uvm_macros.svh"
package wb_uart_tests_pkg;
	import uvm_pkg::*;
	import wb_uart_env_pkg::*;
	import wb_master_agent_pkg::*;
	import sv_bfms_api_pkg::*;
	
	`include "wb_uart_test_base.svh"
	`include "wb_uart_bfm_smoke_test.svh"
	
endpackage
