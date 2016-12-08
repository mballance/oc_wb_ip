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
	`include "wb_dma_transfer_seq.svh"
	`include "wb_dma_rand_single_transfer_seq.svh"
	`include "wb_dma_rand_single_short_transfer_seq.svh"
	`include "wb_dma_rand_single_medium_transfer_seq.svh"
	
`ifdef INFACT
	`include "infact_wb_dma_single_transfer_descriptor_gen.svh"
	`include "infact/wb_dma_infact_single_transfer_seq.svh"
`endif

endpackage


