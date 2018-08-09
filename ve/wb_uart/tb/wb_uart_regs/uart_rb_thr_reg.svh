/****************************************************************************
 * uart_rb_thr_reg.svh
 ****************************************************************************/

/**
 * Class: uart_rb_thr_reg
 * 
 * TODO: Add class documentation
 */
class uart_rb_thr_reg extends uvm_reg;
	`uvm_object_utils(uart_rb_thr_reg)

	rand uvm_reg_field			data;
	
	function new(string name="thr_rb");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		data = uvm_reg_field::type_id::create("data");
		data.configure(this, 8, 0, "RW", 1, 0, 0, 0, 0);
	endfunction

endclass


