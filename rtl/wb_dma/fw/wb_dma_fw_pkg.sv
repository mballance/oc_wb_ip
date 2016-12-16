/****************************************************************************
 * wb_dma_fw_pkg.sv
 ****************************************************************************/

/**
 * Package: wb_dma_fw_pkg
 * 
 * TODO: Add package documentation
 */
package wb_dma_fw_pkg;
	
	class wb_dma_drv_done_f;
	endclass
	
	static wb_dma_drv_done_f	m_done_map[31];
	
	typedef int unsigned		wb_dma_drv_t;
	
	import "DPI-C" context _wb_dma_drv_init=task wb_dma_drv_init(
			output wb_dma_drv_t	drv_id,
			input int unsigned	base,
			input int unsigned	irq_en,
			input chandle		user_data);
	
	import "DPI-C" context _wb_dma_drv_init_single_xfer=task wb_dma_init_single_xfer(
			wb_dma_drv_t		drv_id,
			int unsigned		chan,
			int unsigned		src,
			int unsigned		inc_src,
			int unsigned		dst,
			int unsigned		inc_dst,
			int unsigned		num_words);
	
	import "DPI-C" context _wb_dma_drv_init_linklist_desc=task wb_dma_init_linklist_desc(
			wb_dma_drv_t		drv_id,
			int unsigned		src,
			int unsigned		inc_src,
			int unsigned		dst,
			int unsigned		inc_dst,
			int unsigned		sz,
			int unsigned		desc,
			int unsigned		desc_n);
	
	import "DPI-C" context _wb_dma_drv_init_linklist_xfer=task wb_dma_init_linklist_xfer(
			wb_dma_drv_t		drv_id,
			int unsigned		chan,
			int unsigned		desc);
			
	
	import "DPI-C" context _wb_dma_drv_check_status=task wb_dma_drv_check_status(
			wb_dma_drv_t		drv,
			int					chan,
			output int unsigned	status);
		

	import "DPI-C" context _wb_dma_drv_poll=task wb_dma_drv_poll(
			wb_dma_drv_t		drv_id,
			output int unsigned	done_mask);

endpackage


