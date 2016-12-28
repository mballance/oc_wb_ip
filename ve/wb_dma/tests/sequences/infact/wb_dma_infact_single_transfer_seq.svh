/****************************************************************************
 * wb_dma_infact_single_transfer_seq.svh
 ****************************************************************************/
/**
 * Class: wb_dma_infact_single_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_infact_single_transfer_seq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_infact_single_transfer_seq)

	virtual task body();
		wb_dma_single_transfer_descriptor desc;
		infact_wb_dma_single_transfer_descriptor_gen infact_gen;
		
		infact_gen = new({get_full_name(), ".infact_gen"});
		
		repeat (200) begin
			desc = wb_dma_single_transfer_descriptor::type_id::create("desc");
			
			start_item(desc);
			infact_gen.ifc_fill(desc);
			finish_item(desc);
		end
	endtask

endclass


