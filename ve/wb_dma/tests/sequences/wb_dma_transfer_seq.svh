/****************************************************************************
 * wb_dma_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_transfer_seq extends wb_dma_reg_seq;
	`uvm_object_utils(wb_dma_transfer_seq)


	/**
	 * Task: finish_item
	 *
	 * Override from class 
	 */
	virtual task finish_item(
		input uvm_sequence_item item, 
		input int set_priority=-1);
		uvm_reg_data_t value;
		uvm_status_e status;
		wb_dma_descriptor desc;
		wb_dma_ch ch;
		
		if (!$cast(desc, item)) begin
			`uvm_fatal(get_name(), "Failed to cast item to wb_dma_descriptor");
		end
		
		// Setup appropriate channel
		ch = m_regs.ch[desc.channel];
		
		ch.SZ.CHK_SZ.set(desc.chk_sz);
		ch.SZ.TOT_SZ.set(desc.tot_sz);
		
		// Flush everything except the CSR
		m_regs.update(status);
	
		ch.CSR.INC_SRC.set(desc.inc_src);
		ch.CSR.INC_DST.set(desc.inc_dst);
		ch.CSR.SRC_SEL.set(desc.src_sel);
		ch.CSR.DST_SEL.set(desc.dst_sel);
		ch.CSR.CH_EN.set(1); // enable channel
		// Flush the CSR write
		ch.CSR.update(status);
		
		// Now, wait completion
		repeat(16) begin
			#1us;
			ch.CSR.read(status, value);
			
			if (ch.CSR.DONE.get()) begin
				break;
			end
		end
		
		ch.CSR.read(status, value);
		if (!ch.CSR.DONE.get()) begin
			`uvm_fatal(get_name(), "DMA transfer failed to terminate");
		end
	endtask

	/**
	 * Task: start_item
	 *
	 * Override from class 
	 */
	virtual task start_item(
		input uvm_sequence_item item, 
		input int set_priority=-1, 
		input uvm_sequencer_base sequencer=null);
		// NOP
	endtask

	

endclass


