/****************************************************************************
 * wb_uart_isr.svh
 ****************************************************************************/

/**
 * Class: wb_uart_isr
 * 
 * TODO: Add class documentation
 */
class wb_uart_isr extends uvmdev_isr_base #(event_seq_item);
	`uvm_component_utils(wb_uart_isr)
	mailbox #(int unsigned)		m_mb = new();

	function new(string name, uvm_component parent);
		super.new(name, parent);
		init(1);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		int unsigned id;
		
		forever begin
			m_mb.get(id);
			send_irq(id);
		end
	endtask
		

	virtual function void write(event_seq_item t);
		void'(m_mb.try_put(0));
	endfunction

endclass


