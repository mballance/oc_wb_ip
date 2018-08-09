/****************************************************************************
 * uart_lc_reg.svh
 ****************************************************************************/

/**
 * Class: uart_lc_reg
 * 
 * TODO: Add class documentation
 */
class uart_lc_reg extends uvm_reg;
	`uvm_object_utils(uart_lc_reg)
	uvm_reg_field				bits;
	uvm_reg_field				stop;
	uvm_reg_field				parity;
	uvm_reg_field				even;
	uvm_reg_field				sticky;
	uvm_reg_field				bcont;
	uvm_reg_field				dla;

	function new(string name="uart_lc_reg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	virtual function void build();
		bits = uvm_reg_field::type_id::create("bits");
		bits.configure(this, 2, 0, "RW", 1, 0, 0, 0, 0);
		stop = uvm_reg_field::type_id::create("stop");
		stop.configure(this, 1, 2, "RW", 1, 0, 0, 0, 0);
		parity = uvm_reg_field::type_id::create("parity");
		parity.configure(this, 1, 3, "RW", 1, 0, 0, 0, 0);
		even = uvm_reg_field::type_id::create("even");
		even.configure(this, 1, 4, "RW", 1, 0, 0, 0, 0);
		sticky = uvm_reg_field::type_id::create("sticky");
		sticky.configure(this, 1, 5, "RW", 1, 0, 0, 0, 0);
		bcont = uvm_reg_field::type_id::create("bcont");
		bcont.configure(this, 1, 6, "RW", 1, 0, 0, 0, 0);
		dla = uvm_reg_field::type_id::create("dla");
		dla.configure(this, 1, 7, "RW", 1, 0, 0, 0, 0);
		
	endfunction


endclass


