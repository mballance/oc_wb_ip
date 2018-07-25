
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk

MK_INCLUDES += $(OC_WB_IP)/rtl/wb_dma/fw/rules_defs.mk
MK_INCLUDES += $(SV_BFMS)/api/rules_defs.mk

WB_DMA_VE_DIR=$(OC_WB_IP)/ve/wb_dma
SEQUENCES_DIR=$(WB_DMA_VE_DIR)/tests/sequences
WB_DMA_INFACT_DIR=$(OC_WB_IP)/ve/wb_dma/tests/infact
export WB_DMA_INFACT_DIR

HAVE_INFACT:=$(call have_plusarg,tool.infact,$(PLUSARGS))

CFLAGS += -DUSE_SV_BFMS_RW_API

TB=wb_dma_tb
TB_MODULES=wb_dma_tb 
TIMEOUT = 100ms

INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/library/*.rseg)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/library/uvm/*.rseg)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/library/sc/*.rseg)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/dma/*.rseg)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/dma/*.rules)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/dma/uvm/*.rseg)
INFACT_SRC += $(wildcard $(OC_WB_IP)/ve/wb_dma/tests/infact/dma/sc/*.rseg)

INFACT_SCRIPT = $(OC_WB_IP)/ve/wb_dma/sim/scripts/infact_comps.F

ifeq (true,$(HAVE_INFACT))
BUILD_PRECOMPILE_TARGETS += build_infact.d
BUILD_POSTCOMPILE_TARGETS += run_qso.d
BUILD_PRELINK_TARGETS += compile_qso_seqs.d
TB_MODULES += wb_dma_infact_seqs_pkg
endif

DPI_OBJS_LIBS += $(LIBWB_DMA_FW) $(LIBSV_BFMS_DPI)

include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk


build_infact.d : $(INFACT_SRC) $(INFACT_SCRIPT)
	$(Q)rm -rf infact_dma_seqs
	$(Q)infact cmd create_project infact_dma_seqs
	$(Q)infact cmd add_component -project infact_dma_seqs \
		uvm_sequence dma_single_xfer_seq -rules \
			$(WB_DMA_INFACT_DIR)/dma/dma_single_xfer_test.rules \
			$(WB_DMA_INFACT_DIR)/library/uvm/env_mapping.rseg \
			$(WB_DMA_INFACT_DIR)/library/mem_allocator.rseg \
			$(WB_DMA_INFACT_DIR)/library/resource_pool.rseg \
			$(WB_DMA_INFACT_DIR)/library/resource_pool.rseg \
			$(WB_DMA_INFACT_DIR)/library/threads.rseg \
			$(WB_DMA_INFACT_DIR)/dma/dma_single_xfer.rseg \
			$(WB_DMA_INFACT_DIR)/dma/uvm/dma_single_xfer_mapping.rseg
	$(Q)touch $@
	
run_qso.d :
	$(Q)if test ! -d qso; then mkdir -p qso; fi
	$(Q)cd qso ; qso -work ../work -unit wb_dma_coverage_pkg \
	  wb_dma_env_pkg::wb_dma_descriptor \
	  -covergroup wb_dma_coverage_pkg::wb_dma_single_transfer_descriptor_cov::single_desc_cg \
	  -o wb_dma_infact_single_transfer_descriptor_gen.svh
	  
compile_qso_seqs.d :
	$(Q)echo "compile_qso_seqs.d"
	$(Q)vlog -sv +incdir+$(SEQUENCES_DIR)/infact +incdir+$(BUILD_DIR)/qso \
		$(SEQUENCES_DIR)/infact/wb_dma_infact_seqs_pkg.sv

include $(PACKAGES_DIR)/packages.mk
	


	
