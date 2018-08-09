/****************************************************************************
 * pending.svh
 ****************************************************************************/

/**
 * Class: simple_pic_reg
 * 
 * TODO: Add class documentation
 */
class pending_reg extends uvm_reg;
	`uvm_object_utils(pending_reg)
	
	rand uvm_reg_field			pending;
	

	function new(string name="pending_reg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		pending = uvm_reg_field::type_id::create("pending");
		pending.configure(this, 32, 0, "RO", 1, 0, 1, 0, 0);
	endfunction

endclass


