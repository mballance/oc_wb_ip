/****************************************************************************
 * uart_ie_reg.svh
 ****************************************************************************/

/**
 * Class: uart_ie_reg
 * 
 * TODO: Add class documentation
 */
class uart_ie_reg extends uvm_reg;
	`uvm_object_utils(uart_ie_reg)
	
	rand uvm_reg_field		rx;
	rand uvm_reg_field		tx;
	rand uvm_reg_field		ls;
	rand uvm_reg_field		ms;
	rand uvm_reg_field		rsvd;

	function new(string name="uart_ie");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		rx = uvm_reg_field::type_id::create("rx");
		rx.configure(this, 1, 0, "RW", 1, 0, 0, 0, 0);
		tx = uvm_reg_field::type_id::create("tx");
		tx.configure(this, 1, 1, "RW", 1, 0, 0, 0, 0);
		ls = uvm_reg_field::type_id::create("ls");
		ls.configure(this, 1, 2, "RW", 1, 0, 0, 0, 0);
		ms = uvm_reg_field::type_id::create("ms");
		ms.configure(this, 1, 3, "RW", 1, 0, 0, 0, 0);
		rsvd = uvm_reg_field::type_id::create("rsvd");
		rsvd.configure(this, 4, 4, "RW", 1, 0, 0, 0, 0);
	endfunction

endclass


