/****************************************************************************
 * wb_dma_action_single_xfer.svh
 ****************************************************************************/

/**
 * Class: wb_dma_action_single_xfer
 * 
 * TODO: Add class documentation
 */
class wb_dma_action_single_xfer extends uvm_object;
	wb_dma_action_mgr_if		m_action_mgr;
	wb_dma_dev_api				m_dev;
	int unsigned				m_channel;
	int unsigned				m_src;
	int unsigned				m_inc_src;
	int unsigned				m_dst;
	int unsigned				m_inc_dst;
	int unsigned				m_sz;
		
	function new(
		wb_dma_action_mgr_if	action_mgr,
		wb_dma_dev_api			dev,
		int unsigned			channel,
		int unsigned			src,
		int unsigned			inc_src,
		int unsigned			dst,
		int unsigned			inc_dst,
		int unsigned			sz);
		m_action_mgr = action_mgr;
		m_dev = dev;
		m_channel = channel;
		m_src = src;
		m_inc_src = inc_src;
		m_dst = dst;
		m_inc_dst = inc_dst;
		m_sz = sz;
		
		m_action_mgr.add_action(this);
			
		fork
			run();
		join_none
	endfunction
		
	task run();
		m_action_mgr.add_process(process::self());
		$display("--> single_xfer::run channel=%0d m_src='h%08h m_dst='h%08h sz=%0d", 
				m_channel, m_src, m_dst, m_sz);
		m_dev.init_single_transfer(
				m_channel, m_src, m_inc_src, 
				m_dst, m_inc_dst, m_sz/4);
		m_dev.wait_complete_poll(m_channel);
		$display("<-- single_xfer::run");
	endtask

endclass


