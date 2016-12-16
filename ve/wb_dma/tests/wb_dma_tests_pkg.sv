

`include "uvm_macros.svh"
package wb_dma_tests_pkg;
	import uvm_pkg::*;
	import wb_dma_env_pkg::*;
	import wb_master_agent_pkg::*;
	import sv_bfms_api_pkg::*;
	import wb_dma_seqs_pkg::*;
	import wb_dma_coverage_pkg::*;
	
	`include "wb_dma_test_base.svh"
	`include "wb_dma_register_reset_test.svh"
	`include "wb_dma_register_rw_test.svh"
	`include "wb_dma_register_smoketest.svh"
	
	`include "wb_dma_transfer_test.svh"
	`include "wb_dma_fw_test.svh"
	
endpackage
