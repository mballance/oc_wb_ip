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
		bit[31:0]		addresses[$];
		
		if (!$cast(desc, item)) begin
			`uvm_fatal(get_name(), "Failed to cast item to wb_dma_descriptor");
		end
		
		// Setup appropriate channel
		ch = m_regs.ch[desc.channel];

		// Single transfer
		if (desc.ll_desc_sz == 0) begin
			setup_single_transfer(desc, addresses);
		end else begin // Linked-list descriptor
			setup_ll_transfer(desc, addresses);
		end
		
		if (m_start_ap != null) begin
			m_start_ap.write(desc);
		end
		
		// Flush the CSR write
		ch.CSR.update(status);
		
		// Now, wait completion
		repeat(1000) begin
			#10us;
			ch.CSR.read(status, value);
			
			if (ch.CSR.DONE.get()) begin
				$display("== DONE  CSR='h%08h ==", value);
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
		
		ch.CSR.CH_EN.set(0); // disable channel
		ch.CSR.update(status);

		foreach (addresses[i]) begin
			m_mem_mgr.free(addresses[i]);
		end
	endtask
	
	task setup_single_transfer(
		wb_dma_descriptor		desc,
		bit[31:0]				addresses[$]);
		wb_dma_ch ch = m_regs.ch[desc.channel];
		uvm_status_e status;
		uvm_reg_data_t value;

		m_mem_mgr.malloc(
				desc.src_addr,
				desc.tot_sz*4,
				"Source");
		addresses.push_back(desc.src_addr);
		
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
		addresses.push_back(desc.dst_addr);

		// Disable the channel
		ch.CSR.CH_EN.set(0);
		ch.CSR.update(status);

		// These registers are volatile. Read-back the content
		// so the register model knows to re-write them
		ch.A0.read(status, value);
		ch.A1.read(status, value);
		
		ch.A0.set(desc.src_addr);
		ch.A1.set(desc.dst_addr);
		
		ch.AM0.set('hfffffffc);
		ch.AM1.set('hfffffffc);
		
		ch.SZ.CHK_SZ.set(desc.chk_sz);
		ch.SZ.TOT_SZ.set(desc.tot_sz);
		
		// Flush everything except the CSR
		m_regs.update(status);

		ch.CSR.REST_EN.set(1);
		ch.CSR.SZ_WB.set(1);
		ch.CSR.USE_ED.set(0);
		ch.CSR.ARS.set(0);
		ch.CSR.MODE.set(0);
		ch.CSR.INC_SRC.set(desc.inc_src);
		ch.CSR.INC_DST.set(desc.inc_dst);
		ch.CSR.SRC_SEL.set(desc.src_sel);
		ch.CSR.DST_SEL.set(desc.dst_sel);
		
		`uvm_info (get_name(),
				$psprintf(
					{"== DMA Transfer %0d ==\n",
					"  SRC: 'h%08h (%0d) inc=%0d\n",
					"  DST: 'h%08h (%0d) inc=%0d\n",
					"  SZ:  %0d\n"}, 
					desc.channel,
					desc.src_addr, desc.src_sel, desc.inc_src,
					desc.dst_addr, desc.dst_sel, desc.inc_dst,
					desc.tot_sz), UVM_LOW);
		
		ch.CSR.CH_EN.set(1); // enable channel
	endtask
	
	task setup_ll_transfer(
		wb_dma_descriptor		desc,
		bit[31:0]				addresses[$]);
		wb_dma_ch ch = m_regs.ch[desc.channel];
		uvm_status_e status;
		uvm_reg_data_t value;
		
		for (int i=0; i<desc.ll_desc_sz; i++) begin
			bit[31:0] data;
			
			// Allocate space for the descriptor
			m_mem_mgr.malloc(
					desc.ll_desc[i].desc,
					4*4,
					"LL Desc",
					16);
			addresses.push_back(desc.ll_desc[i].desc);
			
			m_mem_mgr.malloc(
					desc.ll_desc[i].src_addr,
					desc.ll_desc[i].tot_sz*4,
					"LL Src");
			addresses.push_back(desc.ll_desc[i].src_addr);
			
			// Write non-zero data 
			for (int j=0; j<desc.ll_desc[i].tot_sz; j++) begin
				m_mem_mgr.write32(
						desc.ll_desc[i].src_addr+(4*j), j+1);
			end			
			
			m_mem_mgr.malloc(
					desc.ll_desc[i].dst_addr,
					desc.ll_desc[i].tot_sz*4,
					"LL Dst");
			addresses.push_back(desc.ll_desc[i].dst_addr);
		
			data = desc.ll_desc[i].tot_sz;
			data[20] = (i+1 == desc.ll_desc_sz); // EOL
			data[19] = desc.ll_desc[i].inc_src;
			data[18] = desc.ll_desc[i].inc_dst;
			data[17] = desc.ll_desc[i].src_sel;
			data[16] = desc.ll_desc[i].dst_sel;
			
			`uvm_info (get_name(),
				$psprintf(
					{"\n== DMA Transfer %0d [ll_desc=%0d] ==\n",
					"  DESC: 'h%08h\n",
					"  SRC: 'h%08h (%0d) inc=%0d\n",
					"  DST: 'h%08h (%0d) inc=%0d\n",
					"  SZ:  %0d\n"}, 
					desc.channel, i, 
					desc.ll_desc[i].desc,
					desc.ll_desc[i].src_addr, 
					desc.ll_desc[i].src_sel, 
					desc.ll_desc[i].inc_src,
					desc.ll_desc[i].dst_addr, 
					desc.ll_desc[i].dst_sel, 
					desc.ll_desc[i].inc_dst,
					desc.ll_desc[i].tot_sz), UVM_LOW);
		
		ch.CSR.CH_EN.set(1); // enable channel
		
			// Write CSR
			m_mem_mgr.write32(desc.ll_desc[i].desc, data);
		
			// Src Addr
			m_mem_mgr.write32(
					desc.ll_desc[i].desc+4,
					desc.ll_desc[i].src_addr);
			
			// Dst Addr
			m_mem_mgr.write32(
					desc.ll_desc[i].desc+8,
					desc.ll_desc[i].dst_addr);
			
			// Write next pointer for the last entry
			if (i > 0) begin
				m_mem_mgr.write32(
						desc.ll_desc[i-1].desc+12,
						desc.ll_desc[i].desc);
			end
			
			// Clear the next pointer for this entry
			data = 0;
			m_mem_mgr.write32(
					desc.ll_desc[i].desc+12,
					data);
		end

		// Begin the transfer
		
		// Disable the channel
		ch.CSR.CH_EN.set(0);
		ch.CSR.update(status);

		ch.AM0.set('hfffffffc);
		ch.AM1.set('hfffffffc);
	
		// First descriptor in the chain
		ch.DESC.set(desc.ll_desc[0].desc);
		
		ch.SZ.CHK_SZ.set(desc.chk_sz);
		ch.SZ.TOT_SZ.set(desc.tot_sz);
		
		// Flush everything except the CSR
		m_regs.update(status);

		ch.CSR.REST_EN.set(1);
		ch.CSR.SZ_WB.set(1);
		ch.CSR.USE_ED.set(1);
		ch.CSR.ARS.set(0);
		ch.CSR.MODE.set(0);
		
		ch.CSR.CH_EN.set(1); // enable channel
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


