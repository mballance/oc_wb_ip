
WB_SIMPLE_PIC_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(WB_SIMPLE_PIC_FW_DIR)

WB_SIMPLE_PIC_FW_SRC = $(notdir $(wildcard $(WB_SIMPLE_PIC_FW_DIR)/*.c))


else

libwb_simple_pic_fw.o : $(WB_SIMPLE_PIC_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif