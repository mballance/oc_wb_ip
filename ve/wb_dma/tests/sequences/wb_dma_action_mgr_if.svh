/****************************************************************************
 * wb_dma_action_mgr_if.svh
 ****************************************************************************/

/**
 * Class: wb_dma_action_mgr_if
 * 
 * TODO: Add class documentation
 */
interface class wb_dma_action_mgr_if;

	pure virtual function void add_action(uvm_object a);
	
	pure virtual function void add_process(process p);


endclass


