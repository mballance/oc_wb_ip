/****************************************************************************
 * wb_dma_multixfer_vseq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_multixfer_vseq
 * 
 * TODO: Add class documentation
 */
class wb_dma_multixfer_vseq extends wb_dma_transfer_seq;
	// Have registers pre-set

	// Method to track available channels
	bit						m_active_channels[31];
	
	function int get_num_active();
		int active = 0;
		
		for (int i=0; i<31; i++) begin
			if (m_active_channels[i]) begin
				active++;
			end
		end
		
		return active;
	endfunction
	

	/**
	 * Task: finish_item
	 *
	 * Override from class 
	 */
	virtual task finish_item(
		input uvm_sequence_item item, 
		input int set_priority=-1);	
		wb_dma_descriptor desc;

		if (!$cast(desc, item)) begin
			`uvm_fatal(get_name(), "Failed to cast item to wb_dma_descriptor");
		end

	endtask
	
	task do_descriptor(wb_dma_descriptor desc);
		wb_dma_directed_transfer_seq seq = wb_dma_directed_transfer_seq::type_id::create("seq");
		seq.desc = desc;
	
		seq.start();
		
		// Clear the appropriate bit
		m_active_channels[desc.channel] = 0;
	endtask

endclass


