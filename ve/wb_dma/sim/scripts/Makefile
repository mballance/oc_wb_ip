
include $(SIMSCRIPTS_DIR)/mkfiles/plusargs.mk

TB=wb_dma_tb
TIMEOUT = 100ms

INFACT_IMPORT_TARGETS += run_tbi
INFACT_RECOMPILE_TARGETS += recompile_tests

INFACT_BUILDDIR_PROJECTS += infact_imp_proj
INFACT_SRC_PROJECTS += $(SIM_DIR)/../tests/sequences/infact/infact_dma_seqs

include $(SIMSCRIPTS_DIR)/mkfiles/common_sim.mk


TBI_ARGS += -sv_lib work -project infact_imp_proj -unit wb_dma_tests_pkg

run_tbi :
	infact cmd import_testbench $(TBI_ARGS) \
		wb_dma_seqs_pkg::wb_dma_single_transfer_descriptor \
		-disable_field ll_desc -disable_constraint ll_desc_c \
		-covergroup wb_dma_coverage_pkg::wb_dma_single_transfer_descriptor_cov::single_desc_cg
	infact cmd import_testbench $(TBI_ARGS) \
		wb_dma_env_pkg::wb_dma_config \
		-component infact_wb_dma_config_pairwise_gen
	infact cmd create_stimulus_strategy ntuple -name pairwise \
		-exclude wb_dma_config_inst.int_msk_a \
		-exclude wb_dma_config_inst.int_msk_b \
		infact_imp_proj/infact_wb_dma_config_pairwise_gen/infact_wb_dma_config_pairwise_gen.tmd 
	infact cmd import_testbench $(TBI_ARGS) \
		wb_dma_env_pkg::wb_dma_config \
		-component infact_wb_dma_config_fields_gen
	infact cmd create_stimulus_strategy fields -name fields \
		-exclude wb_dma_config_inst.int_msk_a \
		-exclude wb_dma_config_inst.int_msk_b \
		infact_imp_proj/infact_wb_dma_config_fields_gen/infact_wb_dma_config_fields_gen.tmd 
	infact cmd genproject infact_imp_proj
	

recompile_tests : mk_infact_incdir
	vlog +define+INFACT -f infact_incdir.f -F $(SIM_DIR)/../tests/tests.F
	


	