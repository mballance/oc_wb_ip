/****************************************************************************
 * wb_dma_infact_fields_config_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_infact_fields_config_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_infact_fields_config_seq extends wb_dma_config_seq;
	`uvm_object_utils(wb_dma_infact_fields_config_seq)

	task body();
		infact_wb_dma_config_fields_gen infact_gen =
			new({get_full_name(), ".infact_gen"});
		wb_dma_config cfg = wb_dma_config::type_id::create("cfg");
		
		start_item(cfg);
		infact_gen.ifc_fill(cfg);
		finish_item(cfg);
		
	endtask


endclass


