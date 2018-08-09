/****************************************************************************
 * wb_periph_subsys_regblk.svh
 ****************************************************************************/

/**
 * Class: wb_periph_subsys_regblk
 * 
 * TODO: Add class documentation
 */
class wb_periph_subsys_regblk extends uvm_reg_block;
	`uvm_object_utils(wb_periph_subsys_regblk)
	
	wb_simple_pic_regs					m_pic;
	wb_dma_reg_block					m_dma;
	wb_uart_reg_block					m_uart;

	virtual function void build();
		
		m_pic = wb_simple_pic_regs::type_id::create("m_pic");
		m_pic.build();
		m_pic.configure(this);
		
		m_dma = wb_dma_reg_block::type_id::create("m_dma");
		m_dma.build();
		m_dma.configure(this);
		
		m_uart = wb_uart_reg_block::type_id::create("m_uart");
		m_uart.build();
		m_uart.configure(this);
		
		default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		
		default_map.add_submap(m_dma.default_map, 'h0000_0000);
		default_map.add_submap(m_uart.default_map, 'h0000_0400);
		default_map.add_submap(m_pic.default_map, 'h0000_0440);
	
		lock_model();
	endfunction

endclass


