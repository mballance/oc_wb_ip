/****************************************************************************
 * wb_dma_descriptor.svh
 ****************************************************************************/
 

/**
 * Class: wb_dma_descriptor
 * 
 * TODO: Add class documentation
 */
class wb_dma_descriptor extends uvm_sequence_item;
	`uvm_object_utils(wb_dma_descriptor)

	rand bit[5:0]				channel;
	
	rand bit					mode;
	
	rand bit					inc_src;
	rand bit					inc_dst;
	rand bit					src_sel;
	rand bit					dst_sel;
	
	bit[31:0]					src_addr;
	bit[31:0]					dst_addr;

	rand bit[11:0]				tot_sz;
	rand bit[8:0]				chk_sz;
	
	rand bit[31:0]				transfer_sz;
	
	constraint transfer_sz_c {
		transfer_sz <= 16384;
		transfer_sz == tot_sz;
	}
	
	constraint channel_c {
		channel inside {[0:30]};
	}
	
	constraint tot_sz_c {
		tot_sz > 0;
	}
	
	constraint chk_sz_c {
		chk_sz > 0;
	}

endclass


