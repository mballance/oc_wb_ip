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

	`include "wb_dma_reg_seq.svh"
	`include "wb_dma_reg_reset_seq.svh"
	`include "wb_dma_descriptor.svh"
	`include "wb_dma_single_transfer_descriptor.svh"
	`include "wb_dma_transfer_seq.svh"
	`include "wb_dma_rand_single_transfer_seq.svh"

endpackage


