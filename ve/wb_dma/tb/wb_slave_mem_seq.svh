/****************************************************************************
 * wb_slave_mem_seq.svh
 ****************************************************************************/

/**
 * Class: wb_slave_mem_seq
 * 
 * TODO: Add class documentation
 */
class wb_slave_mem_seq #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32) extends wb_slave_seq_base;
	typedef wb_slave_mem_seq #(ADDRESS_WIDTH,DATA_WIDTH) this_t;
	`uvm_object_param_utils (this_t)


	/**
	 * Task: body
	 *
	 * Override from class 
	 */
	virtual task body();
		wb_slave_seq_item #(ADDRESS_WIDTH, DATA_WIDTH) item = 
			wb_slave_seq_item #(ADDRESS_WIDTH,DATA_WIDTH)::type_id::create("item");
			
		start_item(item);
		
		forever begin
			finish_item(item); // finish first item, returning request
			
			$display("TODO: handle request");
			
			start_item(item); // start next item
		end

	endtask

	

	

endclass


