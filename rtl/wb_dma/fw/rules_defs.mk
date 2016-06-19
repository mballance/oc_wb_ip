
ifneq (1,$(RULES))

WB_DMA_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CFLAGS += -I$(WB_DMA_FW_DIR)

WB_DMA_FW_SRC = \
  wb_dma_drv.c \
  wb_dma_drv_dpi.c
  
LIBWB_DMA_FW := libwb_dma_fw.o

else

vpath %.c $(WB_DMA_FW_DIR)

$(LIBWB_DMA_FW) : $(WB_DMA_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif