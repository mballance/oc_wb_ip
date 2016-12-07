/****************************************************************************
 * wb_dma_descriptor.svh
 ****************************************************************************/
 
class wb_dma_ll_descriptor extends uvm_object;
	`uvm_object_utils(wb_dma_ll_descriptor)
	
	rand bit		inc_src;
	rand bit		inc_dst;
	rand bit		src_sel;
	rand bit		dst_sel;
	
	rand bit[11:0]	tot_sz;
	
endclass

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

	rand bit[11:0]				tot_sz;
	rand bit[8:0]				chk_sz;
	
	rand wb_dma_ll_descriptor	ll_desc[];
	
	constraint channel_c {
		channel inside {[0:30]};
	}
	
	constraint tot_sz_c {
		tot_sz > 0;
	}
	
	function new(string name="wb_dma_descriptor");
		ll_desc = new[8];
		foreach (ll_desc[i]) begin
			ll_desc[i] = wb_dma_ll_descriptor::type_id::create("");
		end
	endfunction

endclass


