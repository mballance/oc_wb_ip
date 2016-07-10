
ifneq (1,$(RULES))

WB_UART16550_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CFLAGS += -I$(WB_DMA_FW_DIR)

WB_UART16550_FW_SRC = \
  wb_uart16550_drv.c \
  wb_uart16550_drv_dpi.c \
  
LIBWB_UART16550_FW := libwb_uart16550_fw.o

else

vpath %.c $(WB_UART16550_FW_DIR)

$(LIBWB_UART16550_FW) : $(WB_UART16550_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif