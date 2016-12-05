
ifneq (1,$(RULES))

SIMPLE_PIC_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CFLAGS += -I$(SIMPLE_PIC_FW_DIR)

SIMPLE_PIC_FW_SRC = \
	simple_pic_drv.c \
	simple_pic_drv_dpi.c
  
LIBSIMPLE_PIC_FW := libsimple_pic_fw.o

else

vpath %.c $(SIMPLE_PIC_FW_DIR)

$(LIBSIMPLE_PIC_FW) : $(SIMPLE_PIC_FW_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif