/****************************************************************************
 * wb_dma_infact_seqs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

/**
 * Package: wb_dma_infact_seqs_pkg
 * 
 * TODO: Add package documentation
 */
package wb_dma_infact_seqs_pkg;
	import uvm_pkg::*;
	import wb_dma_env_pkg::*;
	import wb_dma_seqs_pkg::*;
	
	`include "wb_dma_infact_single_transfer_descriptor_gen.svh"

	`include "wb_dma_infact_single_transfer_seq.svh"

endpackage


