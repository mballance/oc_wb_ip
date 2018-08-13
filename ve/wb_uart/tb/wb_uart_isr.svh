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

	function new(string name, uvm_component parent);
		super.new(name, parent);
		init(1);
	endfunction

	virtual function void write(event_seq_item t);
		send_irq(0);
	endfunction

endclass


