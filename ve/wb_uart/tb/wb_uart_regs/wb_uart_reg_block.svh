/****************************************************************************
 * wb_uart_reg_block.svh
 ****************************************************************************/

/**
 * Class: wb_uart_reg_block
 * 
 * TODO: Add class documentation
 */
class wb_uart_reg_block extends uvm_reg_block;
	`uvm_object_utils(wb_uart_reg_block)

	uart_rb_thr_reg					rb_thr;
	uart_ie_reg						ie;
	uart_lc_reg						lc;


	virtual function void build();
		rb_thr = uart_rb_thr_reg::type_id::create("rb_thr");
		rb_thr.build();
		rb_thr.configure(this, null, "RB_THR");
		
		ie = uart_ie_reg::type_id::create("ie");
		ie.build();
		ie.configure(this, null, "IE");
		
		lc = uart_lc_reg::type_id::create("lc");
		lc.build();
		lc.configure(this, null, "LC");
		
		default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		default_map.add_reg(rb_thr, 16'h0000, "RW");
		default_map.add_reg(ie,     16'h0004, "RW");
		default_map.add_reg(lc,     16'h000C, "RW");
		
	endfunction
	
endclass


