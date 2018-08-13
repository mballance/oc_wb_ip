/****************************************************************************
 * uart_ie_reg.svh
 ****************************************************************************/

/**
 * Class: uart_ii_reg
 * 
 * TODO: Add class documentation
 */
class uart_ii_reg extends uvm_reg;
	`uvm_object_utils(uart_ii_reg)
	
	rand uvm_reg_field		pending;
	rand uvm_reg_field		code;

	function new(string name="uart_ii");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		pending = uvm_reg_field::type_id::create("pending");
		pending.configure(this, 1, 0, "RW", 1, 0, 0, 0, 0);
		code = uvm_reg_field::type_id::create("code");
		code.configure(this, 3, 1, "RW", 1, 0, 0, 0, 0);
		
	endfunction

endclass


