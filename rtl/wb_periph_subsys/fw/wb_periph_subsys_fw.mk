
WB_PERIPH_SUBSYS_FW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(WB_PERIPH_SUBSYS_FW_DIR)

else # Rules

endif
