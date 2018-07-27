
WB_DMA_TESTS_INFACT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WB_DMA_TESTS_DIR := $(abspath $(WB_DMA_TESTS_INFACT_DIR)/..)

ifneq (1,$(RULES))

BUILD_PRECOMPILE_TARGETS += build_infact.d
BUILD_POSTCOMPILE_TARGETS += run_qso.d
BUILD_PRELINK_TARGETS += compile_qso_seqs.d
TB_MODULES += wb_dma_infact_seqs_pkg

INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/library/*)
INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/library/uvm/*)
INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/library/sc/*)
INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/dma/*)
INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/dma/uvm/*)
INFACT_SRC += $(wildcard $(WB_DMA_TESTS_INFACT_DIR)/dma/sc/*)

INFACT_INI_FILES += $(BUILD_DIR)/infact_dma_seqs/infact_dma_seqs.ini

LIBRARY_RSEGS = \
			$(WB_DMA_TESTS_INFACT_DIR)/library/mem_allocator.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/library/resource_pool.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/library/resource_pool.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/library/threads.rseg
			
WB_DMA_RSEGS = \
		$(WB_DMA_TESTS_INFACT_DIR)/dma/dma_single_xfer.rseg \
		$(WB_DMA_TESTS_INFACT_DIR)/dma/dma_parallel_xfer.rseg \


else # Rules

build_infact.d : $(INFACT_SRC) $(INFACT_SCRIPT)
	$(Q)rm -rf infact_dma_seqs
	$(Q)infact cmd create_project infact_dma_seqs
	$(Q)infact cmd add_component -project infact_dma_seqs \
		uvm_sequence wb_dma_pss_single_xfer_seq -rules \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/dma_single_xfer_test.rules \
			$(WB_DMA_TESTS_INFACT_DIR)/library/uvm/env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/uvm/dma_env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/uvm/dma_single_xfer_mapping.rseg \
			$(LIBRARY_RSEGS) \
			$(WB_DMA_RSEGS)
	$(Q)infact cmd add_component -project infact_dma_seqs \
		uvm_sequence wb_dma_pss_parallel_xfer_seq -rules \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/dma_parallel_xfer_test.rules \
			$(WB_DMA_TESTS_INFACT_DIR)/library/uvm/env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/uvm/dma_env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/uvm/dma_single_xfer_mapping.rseg \
			$(LIBRARY_RSEGS) \
			$(WB_DMA_RSEGS) \
			-cs $(WB_DMA_TESTS_INFACT_DIR)/dma/dma_parallel_xfer_test_cov.cdf
	$(Q)infact cmd add_component -project infact_dma_seqs \
		sdv_uvm_sequence wb_dma_pss_parallel_xfer_test -rules \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/dma_parallel_xfer_test.rules \
			$(WB_DMA_TESTS_INFACT_DIR)/library/c/env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/c/dma_env_mapping.rseg \
			$(WB_DMA_TESTS_INFACT_DIR)/dma/c/dma_single_xfer_mapping.rseg \
			$(LIBRARY_RSEGS) \
			$(WB_DMA_RSEGS) \
			-cs $(WB_DMA_TESTS_INFACT_DIR)/dma/dma_parallel_xfer_test_cov.cdf \
			-graph-name wb_dma_pss_parallel_xfer_seq
	$(Q)touch $@
	
run_qso.d :
	$(Q)if test ! -d qso; then mkdir -p qso; fi
	$(Q)cd qso ; qso -work ../work -unit wb_dma_coverage_pkg \
	  wb_dma_env_pkg::wb_dma_descriptor \
	  -covergroup wb_dma_coverage_pkg::wb_dma_single_transfer_descriptor_cov::single_desc_cg \
	  -o wb_dma_infact_single_transfer_descriptor_gen.svh
	  
compile_qso_seqs.d :
	$(Q)echo "compile_qso_seqs.d"
	$(Q)vlog -sv \
		+incdir+$(WB_DMA_TESTS_DIR)/sequences/infact \
		+incdir+$(BUILD_DIR)/qso \
		+incdir+$(BUILD_DIR)/infact_dma_seqs \
		$(WB_DMA_TESTS_DIR)/sequences/infact/wb_dma_infact_seqs_pkg.sv

endif

