/****************************************************************************
 * wb_dma_rand_4par_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_rand_4par_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_rand_4par_transfer_seq extends wb_dma_multixfer_vseq;
	`uvm_object_utils(wb_dma_rand_4par_transfer_seq)
	
	task body();
		repeat (16) begin
			bit[5:0] channels[$];
		
			channels = {};
			for (int i=0; i<4; i++) begin
				wb_dma_descriptor desc = wb_dma_descriptor::type_id::create("desc");
			
				start_item(desc);
				if (!desc.randomize()) begin
					`uvm_fatal(get_name(), "Failed to randomize descriptor");
				end
				
				assert(std::randomize(desc.channel) with {
						desc.channel <= 30;
						!(desc.channel inside {channels});
						});
				channels.push_back(desc.channel);
				finish_item(desc);
			end
			
			// Now, wait for completion
			wait_done();
		end
	endtask

endclass


