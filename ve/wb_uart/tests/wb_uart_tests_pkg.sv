

`include "uvm_macros.svh"
package wb_uart_tests_pkg;
	import uvm_pkg::*;
	import uvmdev_pkg::*;
	import wb_uart_env_pkg::*;
	import wb_master_agent_pkg::*;
	import sv_bfms_api_pkg::*;
	import uart_agent_dev_pkg::*;
	import wb_uart_sequences_pkg::*;
	
	`include "wb_uart_test_base.svh"
	`include "wb_uart_bfm_smoke_test.svh"
	`include "wb_uart_irq_tx_test.svh"
	`include "wb_uart_irq_rx_test.svh"
	`include "wb_uart_handshake_tx_test.svh"
	`include "wb_uart_handshake_rx_test.svh"
	`include "wb_uart_vseq_test.svh"
	
endpackage
