

`include "uvm_macros.svh"
package wb_uart16550_tests_pkg;
	import uvm_pkg::*;
	import wb_uart16550_env_pkg::*;
	import sv_bfms_api_pkg::*;
	
	`include "wb_uart16550_test_base.svh"
	`include "wb_uart16550_reg_reset_test.svh"
	`include "wb_uart16550_simple_tx_test.svh"
	
endpackage
