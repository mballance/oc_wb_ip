/*****************************************************************************
 * wb_dma_test_base.f
 *****************************************************************************/
+tool.infact
 
+UVM_TESTNAME=wb_dma_transfer_test
+uvm_set_type_override=wb_dma_transfer_seq,wb_dma_infact_single_transfer_seq
+uvm_set_type_override=wb_dma_config_seq,wb_dma_infact_pairwise_config_seq

