/****************************************************************************
 * wb_simple_pic_regs.svh
 ****************************************************************************/

/**
 * Class: wb_simple_pic_regs
 * 
 * TODO: Add class documentation
 */
class wb_simple_pic_regs extends uvm_reg_block;
	`uvm_object_utils(wb_simple_pic_regs)
	
	edge_enable_reg				edge_enable;
	polarity_reg				polarity;
	mask_reg					mask;
	pending_reg					pending;
	
	virtual function void build();
		
		edge_enable = edge_enable_reg::type_id::create("edge_enable");
		edge_enable.build();
		edge_enable.configure(this, null, "EDGE_ENABLE");
		
		polarity = polarity_reg::type_id::create("polarity");
		polarity.build();
		polarity.configure(this, null, "POLARITY");
		
		mask = mask_reg::type_id::create("mask");
		mask.build();
		mask.configure(this, null, "MASK");
		
		pending = pending_reg::type_id::create("PENDING");
		pending.build();
		pending.configure(this, null, "PENDING");
		
		// Specify a default map
		default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		default_map.add_reg(edge_enable, 16'h0000, "RW");
		default_map.add_reg(polarity,    16'h0004, "RW");
		default_map.add_reg(mask,        16'h0008, "RW");
		default_map.add_reg(pending,     16'h000C, "RO");
		
		lock_model();
	endfunction

endclass


