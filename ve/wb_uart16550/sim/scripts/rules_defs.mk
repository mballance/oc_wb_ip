
ifneq (1,$(RULES))

CFLAGS += -DUSE_SV_BFMS_RW_API
include $(SV_BFMS)/api/rules_defs.mk

DPI_OBJS_LIBS += $(LIBSV_BFMS_DPI)

CFLAGS += \
-I$(SV_BFMS)/utils/c

else # Rules

include $(SV_BFMS)/api/rules_defs.mk

endif
