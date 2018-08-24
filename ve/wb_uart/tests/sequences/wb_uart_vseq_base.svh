/****************************************************************************
 * wb_uart_vseq_base.svh
 ****************************************************************************/

/**
 * Class: wb_uart_vseq_base
 * 
 * TODO: Add class documentation
 */
class wb_uart_vseq_base extends uvm_sequence;
	`uvm_object_utils(wb_uart_vseq_base)

	virtual task body();
		`uvm_fatal(get_name(), "No body specified");
	endtask
endclass


