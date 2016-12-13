/****************************************************************************
 * wb_dma_single_transfer_descriptor.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_transfer_descriptor
 * 
 * TODO: Add class documentation
 */
class wb_dma_single_transfer_descriptor extends wb_dma_descriptor;
	`uvm_object_utils(wb_dma_single_transfer_descriptor)

	// disable linked-list transfers
	constraint ll_desc_sz_c {
		ll_desc_sz == 0;
	}

endclass


