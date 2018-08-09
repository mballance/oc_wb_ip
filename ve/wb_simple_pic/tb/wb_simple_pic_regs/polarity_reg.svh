/****************************************************************************
 * polarity.svh
 ****************************************************************************/

/**
 * Class: simple_pic_reg
 * 
 * TODO: Add class documentation
 */
class polarity_reg extends uvm_reg;
	`uvm_object_utils(polarity_reg)
	
	rand uvm_reg_field			polarity;
	

	function new(string name="polarity_reg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		polarity = uvm_reg_field::type_id::create("polarity");
		polarity.configure(this, 32, 0, "RW", 1, 0, 1, 0, 0);
	endfunction

endclass


