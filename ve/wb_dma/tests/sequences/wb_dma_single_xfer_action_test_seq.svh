/****************************************************************************
 * wb_dma_single_xfer_action_test_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_xfer_action_test_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_single_xfer_action_test_seq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_single_xfer_action_test_seq)

	virtual task body();
		$display("--> queue");
		
		queue_dma_single_transfer(
				0,
				0,
				'h0000_1000,
				1,
				'h0000_2000,
				1,
				'h100);
		$display("<-- queue");
		
		$display("--> wait_threads");
		wait_threads();
		$display("<-- wait_threads");
		
	endtask

endclass


