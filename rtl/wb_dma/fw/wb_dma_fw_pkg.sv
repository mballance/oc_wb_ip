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
	
	static wb_dma_drv_done_f			m_done_map[31];
	
	typedef int unsigned		wb_dma_drv_t;
	
	import "DPI-C" context _wb_dma_drv_init=task wb_dma_drv_init(
			output wb_dma_drv_t	drv_id,
			input int unsigned	base,
			input int unsigned	irq_en,
			input chandle		user_data);
	
	import "DPI-C" context task _wb_dma_drv_begin_xfer(
			wb_dma_drv_t		drv_id,
			int unsigned		src,
			int unsigned		dst,
			int unsigned		num_words,
			output int			chan);
	
	task wb_dma_drv_begin_xfer(
		wb_dma_drv_t			drv_id,
		int unsigned			src,
		int unsigned			dst,
		int unsigned			num_words,
		wb_dma_drv_done_f		done_func,
		// TODO: end-transfer function
		output int				chan
		);
		_wb_dma_drv_begin_xfer(drv_id, src, dst, num_words, chan);
	endtask
	
	import "DPI-C" context _wb_dma_drv_check_status=task wb_dma_drv_check_status(
			wb_dma_drv_t		drv,
			int					chan,
			output int unsigned	status);
		

	import "DPI-C" context _wb_dma_drv_poll=task wb_dma_drv_poll(
			wb_dma_drv_t		drv_id,
			output int unsigned	n_done);

endpackage


