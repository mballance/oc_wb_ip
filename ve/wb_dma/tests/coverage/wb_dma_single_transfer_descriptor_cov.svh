/****************************************************************************
 * wb_dma_single_transfer_descriptor_cov.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_transfer_descriptor_cov
 * 
 * TODO: Add class documentation
 */
class wb_dma_single_transfer_descriptor_cov extends uvm_subscriber #(wb_dma_descriptor);
	`uvm_component_utils(wb_dma_single_transfer_descriptor_cov)
	
	wb_dma_descriptor			desc;
	
	covergroup single_desc_cg;
		
		channel_cp : coverpoint desc.channel {
			bins channels[] = {[0:30]};
		}
		
		tot_sz_cp : coverpoint desc.tot_sz {
			bins small_xfer[] = {[1:16]};
			bins med_xfer[16] = {[16:4089]};
			bins huge_xfer[] = {[4090:4095]};
		}
		
		chk_sz_cp : coverpoint desc.chk_sz {
			bins small_chk[] = {[1:15]};
//			bins large_chk[] = {[16:256]};
		}
		
		chk_tot_sz_cross : cross tot_sz_cp, chk_sz_cp;
		
		src_cp     : coverpoint desc.src_sel;
		dst_cp     : coverpoint desc.dst_sel;
		inc_src_cp : coverpoint desc.inc_src;
		inc_dst_cp : coverpoint desc.inc_dst;
		
		src_dst_inc_cross : cross src_cp, dst_cp, inc_src_cp, inc_dst_cp;
		
	endgroup
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		single_desc_cg = new();
	endfunction

	/**
	 * Function: write
	 *
	 * Override from class 
	 */
	virtual function void write(input T t);
		desc = t;
		if (t.ll_desc_sz == 0) begin
			single_desc_cg.sample();
		end
	endfunction

endclass


