/****************************************************************************
 * wb_dma_dev.svh
 ****************************************************************************/

/**
 * Class: wb_dma_dev
 * 
 * TODO: Add class documentation
 */
class wb_dma_dev extends uvm_report_object
		implements uvmdev_if, uvmdev_irq_if;
	`uvm_object_utils(wb_dma_dev);
	wb_dma_reg_block			m_regs;
	bit							m_active[];
	semaphore					m_sem[];
	
	function new(wb_dma_reg_block regs=null);
		m_regs = regs;
		
		m_active = new[32];
		m_sem = new[32];
		
		foreach (m_sem[i]) begin
			m_sem[i] = new(0);
		end
	endfunction
	
	virtual task init();
		uvm_status_e status;
		uvm_reg_data_t value;
	
		value = 'hffff_ffff;
		m_regs.int_msk_a.write(status, value);
	
		// Don't send interrupts through intb
		value = 'h0000_0000;
		m_regs.int_msk_b.write(status, value);
	
		// Configure channel defaults
		for (int i=0; i<8; i++) begin
			wb_dma_ch ch = m_regs.ch[i];
			ch.CSR.read(status, value);
			value[18] = 1; // enable completion interrupt
			ch.CSR.write(status, value);
			ch.SZ.read(status, value);
			value[24:16] = 16; // default to 16-byte chunk size
			ch.SZ.write(status, value);
		end
		
	endtask
	
	virtual task irq(int unsigned id);
		uvm_status_e status;
		uvm_reg_data_t value;
		
		m_regs.int_src_a.read(status, value);
		`uvm_info(get_name(), $sformatf("Received IRQ SRC='h%08h", value), UVM_LOW);
		
		for (int i=0; i<32; i++) begin
			if (value[i]) begin
				`uvm_info(get_name(), $sformatf("Channel %0d active", i), UVM_LOW);
				if (m_active[i]) begin
					uvm_status_e status_t;
					uvm_reg_data_t value_t;
					wb_dma_ch ch = m_regs.ch[i];
					`uvm_info(get_name(), $sformatf("--> acknowledge channel %0d", i), UVM_LOW);
					// Read the CSR to clear the interrupt
					ch.CSR.read(status_t, value_t);
					m_sem[i].put(1);
					`uvm_info(get_name(), $sformatf("<-- acknowledge channel %0d", i), UVM_LOW);
				end else begin
					`uvm_fatal(get_name(), $sformatf("Interrupt on inactive channel %0d", i));
				end
			end
		end
	endtask
	
	task set_channel_priority(
		int unsigned			channel,
		int unsigned			pri);
		wb_dma_ch ch = m_regs.ch[channel];
		uvm_status_e status;
		uvm_reg_data_t value;
		
		ch.CSR.read(status, value);
		value[15:13] = pri;
		ch.CSR.write(status, value);
	endtask
	
	task set_channel_mode(
		int unsigned			channel,
		bit						mode,
		bit						rest_en);
		wb_dma_ch ch = m_regs.ch[channel];
		uvm_status_e status;
		uvm_reg_data_t value;
		
		ch.CSR.read(status, value);
		value[5]  = mode;
		value[16] = rest_en;
		ch.CSR.write(status, value);
	
		// Set the chunk size to 1 in the case of device transfers
		ch.SZ.read(status, value);
		value[24:16] = (mode)?1:16;
		ch.SZ.write(status, value);
	endtask
	
	task set_channel_irq(
		int unsigned			channel,
		bit						ine_chk_done,
		bit						ine_done,
		bit						ine_err);
		wb_dma_ch ch = m_regs.ch[channel];
		uvm_status_e status;
		uvm_reg_data_t value;
		
		ch.CSR.read(status, value);
		value[19] = ine_chk_done;
		value[18] = ine_done;
		value[17] = ine_err;
		ch.CSR.write(status, value);
	endtask
	
	task init_single_transfer(
		int unsigned			channel,
		int unsigned			src,
		int unsigned			inc_src,
		int unsigned			dst,
		int unsigned			inc_dst,
		int unsigned			sz
		);
		wb_dma_ch ch = m_regs.ch[channel];
		uvm_status_e status;
		uvm_reg_data_t value;
		
		
		// Disable the channel
		ch.CSR.read(status, value);
		value[0] = 0;
		ch.CSR.write(status, value);

		// These registers are volatile. Read-back the content
		// so the register model knows to re-write them
		ch.A0.read(status, value);
		ch.A1.read(status, value);
		
		ch.A0.write(status, src);
		ch.A1.write(status, dst);
		
		ch.AM0.write(status, 'hfffffffc);
		ch.AM1.write(status, 'hfffffffc);

		ch.SZ.read(status, value);
		value[11:0] = sz;
		ch.SZ.write(status, value);
	
		ch.CSR.read(status, value);
//		value[18] = 1; // INE_DONE
//		value[16] = 1; // REST_EN
//		value[8] = 1;  // SZ_WB
//		value[7] = 0;  // USE_ED
//		value[6] = 0;  // ARS
//		value[5] = 0;  // MODE
		value[4] = inc_src; // INC_SRC
		value[3] = inc_dst; // INC_DST
		value[2] = 0; // TODO: SRC_SEL
		value[1] = 1; // TODO: DST_SEL
		value[0] = 1; // EN
		
		ch.CSR.write(status, value);
	endtask
	
	task single_transfer(
		int unsigned			channel,
		int unsigned			src,
		int unsigned			inc_src,
		int unsigned			dst,
		int unsigned			inc_dst,
		int unsigned			sz);
		init_single_transfer(channel, src, inc_src, dst, inc_dst, sz);
		wait_complete_irq(channel);
	endtask
	
	task mem2mem_transfer(
		int unsigned			channel,
		int unsigned			src,
		int unsigned			dst,
		int unsigned			sz);
		init_single_transfer(channel, src, 1, dst, 1, sz);
		wait_complete_irq(channel);
	endtask
	
	task mem2dev_transfer(
		int unsigned			channel,
		int unsigned			src,
		int unsigned			dst,
		int unsigned			sz);
		init_single_transfer(channel, src, 1, dst, 0, sz);
		wait_complete_irq(channel);
	endtask
	
	task dev2mem_transfer(
		int unsigned			channel,
		int unsigned			src,
		int unsigned			dst,
		int unsigned			sz);
		init_single_transfer(channel, src, 0, dst, 1, sz);
		wait_complete_irq(channel);
	endtask
	
	task wait_complete_poll(
		int unsigned			channel);
		wb_dma_ch ch = m_regs.ch[channel];
		uvm_reg_data_t value;
		uvm_status_e status;
		
		// Now, wait completion
		repeat(1000) begin
			#10us;
			ch.CSR.read(status, value);
			
			if (value[11]) begin
				$display("== DONE  CSR='h%08h ==", value);
//				if (m_done_ap != null) begin
//					m_done_ap.write(desc);
//				end
				break;
			end
		end
		
		ch.CSR.read(status, value);
		if (!value[11]) begin
			`uvm_fatal(get_name(), "DMA transfer failed to terminate");
		end
	
		ch.CSR.read(status, value);
		value[0] = 0;
		ch.CSR.write(status, value);
	endtask
	
	task wait_complete_irq(int unsigned channel);
		m_active[channel] = 1;
		$display("--> Wait IRQ %0d", channel);
		m_sem[channel].get(1);
		$display("<-- Wait IRQ %0d", channel);
		m_active[channel] = 0;
	endtask

endclass

`uvmdev_closure_decl_6(wb_dma_dev, single_transfer, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t)
`uvmdev_closure_decl_4(wb_dma_dev, mem2mem_transfer, uint32_t, uint32_t, uint32_t, uint32_t)
`uvmdev_closure_decl_4(wb_dma_dev, mem2dev_transfer, uint32_t, uint32_t, uint32_t, uint32_t)
`uvmdev_closure_decl_4(wb_dma_dev, dev2mem_transfer, uint32_t, uint32_t, uint32_t, uint32_t)

