/****************************************************************************
 * wb_uart_dev.svh
 ****************************************************************************/

/**
 * Class: wb_uart_dev
 * 
 * TODO: Add class documentation
 */
class wb_uart_dev extends uvm_object implements uvmdev_if;
	`uvm_object_utils(wb_uart_dev)
	wb_uart_reg_block			m_regs;
	

	function void set_regs(wb_uart_reg_block regblk);
		m_regs = regblk;
	endfunction
	
	
	virtual task init();
		uvm_status_e   status;
		uvm_reg_data_t lc;
		uvm_reg_data_t value;
		
		m_regs.lc.read(status, lc);
		lc[7] = 1; // enable access to DLAB
		m_regs.lc.write(status, lc);
		
		value = 0; // Write DLAB1
		m_regs.ie.write(status, value);
		
		value = 14; // Write DLAB0
		m_regs.rb_thr.write(status, value);
		
		lc[7] = 0; // disable access to DLAB
		m_regs.lc.write(status, lc);
		
	endtask


endclass


