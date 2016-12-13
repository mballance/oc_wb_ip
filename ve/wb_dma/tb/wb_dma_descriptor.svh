/****************************************************************************
 * wb_dma_descriptor.svh
 ****************************************************************************/
 
class wb_dma_ll_descriptor extends uvm_object;
	`uvm_object_utils(wb_dma_ll_descriptor)
	
	
	rand bit		inc_src;
	rand bit		inc_dst;
	rand bit		src_sel;
	rand bit		dst_sel;
	
	bit[31:0]		src_addr;
	bit[31:0]		dst_addr;
	
	rand bit[11:0]	tot_sz;
	
	bit[31:0]		desc;
	
	constraint tot_sz_c {
		tot_sz > 0;
	}
	
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
	
	bit[31:0]					src_addr;
	bit[31:0]					dst_addr;

	rand bit[11:0]				tot_sz;
	rand bit[8:0]				chk_sz;
	
	rand wb_dma_ll_descriptor	ll_desc[16];
	rand bit[15:0]				ll_desc_sz;

	// Total size of a linked-list transfer
	rand bit[31:0]				ll_desc_tot_sz[16];
	rand bit[31:0]				transfer_sz;
	
	constraint ll_desc_sz_c {
		ll_desc_sz inside {[0:16]};
	}
	
	constraint ll_desc_tot_sz_c {
		if (ll_desc_sz > 0) {
			foreach (ll_desc[i]) {
				if (i < ll_desc_sz) {
					ll_desc_tot_sz[i] == ll_desc[i].tot_sz;
				} else {
					ll_desc_tot_sz[i] == 0;
				}
			}
			transfer_sz == ll_desc_tot_sz.sum;
		} else {
			transfer_sz == tot_sz;
		}
	}
	
	constraint transfer_sz_c {
		transfer_sz <= 16384;
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
	
	function new(string name="wb_dma_descriptor");
		foreach (ll_desc[i]) begin
			ll_desc[i] = wb_dma_ll_descriptor::type_id::create("");
		end
	endfunction

endclass


