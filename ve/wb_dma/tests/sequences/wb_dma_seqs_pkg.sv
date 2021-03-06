/****************************************************************************
 * wb_dma_seqs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"
`include "uvmdev_macros.svh"

/**
 * Package: wb_dma_seqs_pkg
 * 
 * TODO: Add package documentation
 */
package wb_dma_seqs_pkg;
	import uvm_pkg::*;
	import wb_dma_regs_pkg::*;
	import wb_dma_env_pkg::*;
	import mem_mgr_pkg::*;
	import wb_dma_fw_pkg::*;
	import uvmdev_pkg::*;
	import wb_dma_dev_pkg::*;

	`include "wb_dma_reg_seq.svh"
	`include "wb_dma_reg_reset_seq.svh"
	`include "wb_dma_single_transfer_descriptor.svh"
	`include "wb_dma_single_short_transfer_descriptor.svh"
	`include "wb_dma_single_medium_transfer_descriptor.svh"
	
	`include "wb_dma_ll_transfer_descriptor.svh"
	
	`include "wb_dma_dev_api.svh"
	
	// Transfer sequences
	`include "wb_dma_transfer_seq.svh"
	`include "wb_dma_rand_single_transfer_seq.svh"
	`include "wb_dma_rand_single_short_transfer_seq.svh"
	`include "wb_dma_rand_single_medium_transfer_seq.svh"
	
	`include "wb_dma_rand_ll_transfer_seq.svh"
	`include "wb_dma_directed_transfer_seq.svh"
	
	`include "wb_dma_multixfer_vseq.svh"
	`include "wb_dma_rand_4par_transfer_seq.svh"
	
	// SW Sequences
	`include "wb_dma_multixfer_sw_seq.svh"
	`include "wb_dma_rand_single_sw_transfer_seq.svh"
	
	// Config sequences
	`include "wb_dma_config_seq.svh"
	`include "wb_dma_rand_config_seq.svh"
	
	// Test sequences
	`include "wb_dma_single_xfer_action_test_seq.svh"
	
`ifdef UNDEFINED	
`ifdef INFACT
	`include "infact_wb_dma_single_transfer_descriptor_gen/infact_wb_dma_single_transfer_descriptor_gen.svh"
	`include "infact/wb_dma_infact_single_transfer_seq.svh"
		
	`include "infact_wb_dma_config_pairwise_gen/infact_wb_dma_config_pairwise_gen.svh"
	`include "infact/wb_dma_infact_pairwise_config_seq.svh"
		
	`include "infact_wb_dma_config_fields_gen/infact_wb_dma_config_fields_gen.svh"
	`include "infact/wb_dma_infact_fields_config_seq.svh"
		
	`include "wb_dma_infact_4par_seq/wb_dma_infact_4par_seq.svh"
`endif
`endif

endpackage


