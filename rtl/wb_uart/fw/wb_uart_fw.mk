
ifneq (1,$(RULES))

WB_UART_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

WB_UART_FW_SRC = $(notdir $(wildcard $(WB_UART_FW_DIR)/*.c))

SRC_DIRS += $(WB_UART_FW_DIR)

else # Rules

libwb_uart_fw.o : $(WB_UART_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^
	
endif