/****************************************************************************
 * edge_enable.svh
 ****************************************************************************/

/**
 * Class: simple_pic_reg
 * 
 * TODO: Add class documentation
 */
class edge_enable_reg extends uvm_reg;
	`uvm_object_utils(edge_enable_reg)
	
	rand uvm_reg_field			edge_enable;
	

	function new(string name="edge_enable_reg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		edge_enable = uvm_reg_field::type_id::create("edge_enable");
		edge_enable.configure(this, 32, 0, "RW", 1, 0, 1, 0, 0);
	endfunction

endclass


