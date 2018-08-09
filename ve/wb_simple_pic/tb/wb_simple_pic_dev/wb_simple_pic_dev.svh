/****************************************************************************
 * wb_simple_pic_dev.svh
 ****************************************************************************/

/**
 * Class: wb_simple_pic_dev
 * 
 * TODO: Add class documentation
 */
class wb_simple_pic_dev extends uvm_object implements uvmdev_if;
	`uvm_object_utils(wb_simple_pic_dev)
	wb_simple_pic_regs			m_regs;

	function new(
		string name="wb_simple_pic_dev", 
		wb_simple_pic_regs		regs=null);
		super.new(name);
		m_regs = regs;
	endfunction
	

	virtual task init();
		uvm_status_e status;
		uvm_reg_data_t value;
		
		value = 'hFFFF_FFFF; // Mask all interrupts
		m_regs.mask.write(status, value);
		
		value = 'hFFFF_FFFF; // Set active-high
		m_regs.polarity.write(status, value);
		
		value = 'hFFFF_FFFF; // Clear all active interrupts
		m_regs.pending.write(status, value);
	endtask
	
	virtual task en_irq(int unsigned irq, bit en=1);
		uvm_status_e status;
		uvm_reg_data_t value;
	
		m_regs.mask.read(status, value);
		$display("%0t PIC MASK='h%08h", $time, value);
		value[irq] = (en)?0:1; // enable
		m_regs.mask.write(status, value);
		$display("%0t => PIC MASK='h%08h", $time, value);
	endtask
	
	virtual task get_pending(output int unsigned pending);
		uvm_status_e status;
		uvm_reg_data_t value;
		
		m_regs.pending.read(status, value);
		
		pending = value;
	endtask
	
	virtual task clr_pending(int unsigned clr);
		uvm_status_e status;
		uvm_reg_data_t value = clr;
		
		m_regs.pending.write(status, value);
	endtask
	

endclass


