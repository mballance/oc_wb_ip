/****************************************************************************
 * mask.svh
 ****************************************************************************/

/**
 * Class: simple_pic_reg
 * 
 * TODO: Add class documentation
 */
class mask_reg extends uvm_reg;
	`uvm_object_utils(mask_reg)
	
	rand uvm_reg_field			mask;
	

	function new(string name="mask_reg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		mask = uvm_reg_field::type_id::create("mask");
		mask.configure(this,32, 0, "RW", 1, 0, 1, 0, 0);
	endfunction

endclass


