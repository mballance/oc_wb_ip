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
	
	uvm_analysis_port #(wb_dma_descriptor)		m_start_ap;
	uvm_analysis_port #(wb_dma_descriptor)		m_done_ap;
	
	mem_mgr										m_mem_mgr;


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
		
		m_mem_mgr.malloc(
				desc.src_addr,
				desc.tot_sz*4,
				"Source");
		
		// Write non-zero data 
		for (int i=0; i<desc.tot_sz; i++) begin
			bit[31:0] data = (i+1);
			
			m_mem_mgr.direct_access(
					desc.src_addr+(4*i),
					1,
					data);
		end
		
		m_mem_mgr.malloc(
				desc.dst_addr,
				desc.tot_sz*4,
				"Source");
		
		ch.A0.set(desc.src_addr);
		ch.A1.set(desc.dst_addr);
		
		ch.AM0.set('hfffffffc);
		ch.AM1.set('hfffffffc);
		
		ch.SZ.CHK_SZ.set(desc.chk_sz);
		ch.SZ.TOT_SZ.set(desc.tot_sz);
		
		// Flush everything except the CSR
		m_regs.update(status);
	
		ch.CSR.INC_SRC.set(desc.inc_src);
		ch.CSR.INC_DST.set(desc.inc_dst);
		ch.CSR.SRC_SEL.set(desc.src_sel);
		ch.CSR.DST_SEL.set(desc.dst_sel);
		
		`uvm_info (get_name(),
				$psprintf(
					{"== DMA Transfer ==\n",
					"  SRC: 'h%08h (%0d) inc=%0d\n",
					"  DST: 'h%08h (%0d) inc=%0d\n",
					"  SZ:  %0d\n"}, 
					desc.src_addr, desc.src_sel, desc.inc_src,
					desc.dst_addr, desc.dst_sel, desc.inc_dst,
					desc.tot_sz), UVM_LOW);
		
		ch.CSR.CH_EN.set(1); // enable channel
		
		if (m_start_ap != null) begin
			m_start_ap.write(desc);
		end
		
		// Flush the CSR write
		ch.CSR.update(status);
		
		// Now, wait completion
		repeat(16) begin
			#1us;
			ch.CSR.read(status, value);
			
			if (ch.CSR.DONE.get()) begin
				$display("== DONE ==");
				if (m_done_ap != null) begin
					m_done_ap.write(desc);
				end
				break;
			end
		end
		
		ch.CSR.read(status, value);
		if (!ch.CSR.DONE.get()) begin
			`uvm_fatal(get_name(), "DMA transfer failed to terminate");
		end
		
		m_mem_mgr.free(desc.src_addr);
		m_mem_mgr.free(desc.dst_addr);
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


