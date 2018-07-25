
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk

MK_INCLUDES += $(OC_WB_IP)/rtl/wb_dma/fw/rules_defs.mk
MK_INCLUDES += $(SV_BFMS)/api/rules_defs.mk

WB_DMA_VE_DIR=$(OC_WB_IP)/ve/wb_dma
SEQUENCES_DIR=$(WB_DMA_VE_DIR)/tests/sequences
export WB_DMA_INFACT_DIR

HAVE_INFACT:=$(call have_plusarg,tool.infact,$(PLUSARGS))

# Bring in the inFact makefile is inFact is enabled
ifeq (true,$(HAVE_INFACT))
MK_INCLUDES += $(WB_DMA_VE_DIR)/tests/infact/infact.mk
endif

TB=wb_dma_tb
TB_MODULES=wb_dma_tb 
TIMEOUT = 100ms


DPI_OBJS_LIBS += $(LIBWB_DMA_FW) $(LIBSV_BFMS_DPI)

include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk


	

include $(PACKAGES_DIR)/packages.mk
	


	
