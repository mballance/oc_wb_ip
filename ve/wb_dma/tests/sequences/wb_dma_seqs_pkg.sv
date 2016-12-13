/****************************************************************************
 * wb_dma_seqs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

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

	`include "wb_dma_reg_seq.svh"
	`include "wb_dma_reg_reset_seq.svh"
	`include "wb_dma_single_transfer_descriptor.svh"
	`include "wb_dma_single_short_transfer_descriptor.svh"
	`include "wb_dma_single_medium_transfer_descriptor.svh"
	
	`include "wb_dma_ll_transfer_descriptor.svh"
	
	// Transfer sequences
	`include "wb_dma_transfer_seq.svh"
	`include "wb_dma_rand_single_transfer_seq.svh"
	`include "wb_dma_rand_single_short_transfer_seq.svh"
	`include "wb_dma_rand_single_medium_transfer_seq.svh"
	
	`include "wb_dma_rand_ll_transfer_seq.svh"
	
	// Config sequences
	`include "wb_dma_config_seq.svh"
	`include "wb_dma_rand_config_seq.svh"
	
`ifdef INFACT
	`include "infact_wb_dma_single_transfer_descriptor_gen.svh"
	`include "infact/wb_dma_infact_single_transfer_seq.svh"
		
	`include "infact_wb_dma_config_pairwise_gen.svh"
	`include "infact/wb_dma_infact_pairwise_config_seq.svh"
		
	`include "infact_wb_dma_config_fields_gen.svh"
	`include "infact/wb_dma_infact_fields_config_seq.svh"
`endif

endpackage


