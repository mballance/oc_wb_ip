
include $(SIMSCRIPTS_DIR)/mkfiles/plusargs.mk

TB=wb_dma_tb
TIMEOUT = 100ms

INFACT_IMPORT_TARGETS += run_tbi
INFACT_RECOMPILE_TARGETS += recompile_tests

INFACT_BUILDDIR_PROJECTS += infact_imp_proj

include $(SIMSCRIPTS_DIR)/mkfiles/common_sim.mk


TBI_ARGS += -sv_lib work -project infact_imp_proj -unit wb_dma_tests_pkg

run_tbi :
	infact cmd import_testbench $(TBI_ARGS) \
		wb_dma_seqs_pkg::wb_dma_single_transfer_descriptor \
		-disable_field ll_desc -disable_constraint ll_desc_c \
		-covergroup wb_dma_coverage_pkg::wb_dma_single_transfer_descriptor_cov::single_desc_cg
	echo "Do Nothing"
	

recompile_tests : mk_infact_incdir
	vlog +define+INFACT -f infact_incdir.f -F $(SIM_DIR)/../tests/tests.F
	


	