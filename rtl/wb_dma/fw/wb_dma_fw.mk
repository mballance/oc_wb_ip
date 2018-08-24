
WB_DMA_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(WB_DMA_FW_DIR)

WB_DMA_FW_SRC = $(notdir $(wildcard $(WB_DMA_FW_DIR)/*.c))
  
LIBWB_DMA_FW := libwb_dma_fw.o

else # Rules

$(LIBWB_DMA_FW) : $(WB_DMA_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif