/****************************************************************************
 * wb_dma_dev_api.svh
 ****************************************************************************/

/**
 * Class: wb_dma_dev_api
 * 
 * TODO: Add class documentation
 */
class wb_dma_dev_api extends uvm_object;
	`uvm_object_utils(wb_dma_dev_api);
	wb_dma_reg_block			m_regs;
	
	function new(wb_dma_reg_block regs=null);
		m_regs = regs;
	endfunction

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
		value[24:16] = 16; // TODO
		value[11:0] = sz;
		ch.SZ.write(status, value);
	
		ch.CSR.read(status, value);
		value[16] = 1; // REST_EN
		value[8] = 1; // SZ_WB
		value[7] = 0; // USE_ED
		value[6] = 0; // ARS
		value[5] = 0; // MODE
		value[4] = inc_src; // INC_SRC
		value[3] = inc_dst; // INC_DST
		value[2] = 0; // TODO: SRC_SEL
		value[1] = 1; // TODO: DST_SEL
		value[0] = 1; // EN
		
		ch.CSR.write(status, value);
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

endclass


