#****************************************************************************
#* ivpm.mk
#*
#* Makefile template for a Chisel project
#****************************************************************************
BUILD_DEPS = $(OC_WB_IP_JAR)
SCRIPTS_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ROOT_DIR := $(abspath $(SCRIPTS_DIR)/..)
PROJECT := $(notdir $(ROOT_DIR))
PACKAGES_DIR ?= $(ROOT_DIR)/packages
LIB_DIR = $(ROOT_DIR)/lib

ifneq (true,$(VERBOSE))
Q=@
endif

# Must support dual modes: 
# - build dependencies if this project is the active one
# - rely on the upper-level makefile to resolve dependencies if we're not
-include $(PACKAGES_DIR)/packages.mk
include $(ROOT_DIR)/etc/ivpm.info

# Include makefiles with dependencies
MK_INCLUDES += $(PACKAGES_DIR)/chiselscripts/mkfiles/chiselscripts.mk
MK_INCLUDES += $(PACKAGES_DIR)/chisellib/mkfiles/chisellib.mk
MK_INCLUDES += $(PACKAGES_DIR)/std_protocol_if/mkfiles/std_protocol_if.mk
#MK_INCLUDES += $(PACKAGES_DIR)/sv_bfms/mkfiles/sv_bfms.mk
MK_INCLUDES += $(wildcard $(ROOT_DIR)/mkfiles/*.mk)

include $(MK_INCLUDES)

SRC_DIRS += $(PROJECT)/wb_dma $(PROJECT)/wb_uart

SRC := $(foreach dir,$(SRC_DIRS),$(wildcard $(ROOT_DIR)/src/$(dir)/*.scala))

RULES := 1

ifeq (true,$(PHASE2))
build : $(BUILD_DEPS)
	echo "BUILD_DEPS=$(BUILD_DEPS) OC_WB_IP_JAR=$(OC_WB_IP_JAR)"
else
build : $($(PROJECT)_deps)
	$(Q)$(MAKE) -f $(SCRIPTS_DIR)/ivpm.mk PHASE2=true VERBOSE=$(VERBOSE) build
endif

# TODO: Change Makefile targets
$(OC_WB_IP_JAR) : $(SRC) $(OC_WB_IP_DEPS)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(DO_CHISELC)

release : build
	$(Q)rm -rf $(ROOT_DIR)/build
	$(Q)mkdir -p $(ROOT_DIR)/build/$(PROJECT)
	$(Q)cp -r \
          $(ROOT_DIR)/lib \
          $(ROOT_DIR)/etc \
          $(ROOT_DIR)/build/$(PROJECT)
	$(Q)cd $(ROOT_DIR)/build ; \
		tar czf $(PROJECT)-$(version).tar.gz $(PROJECT)
	$(Q)rm -rf $(ROOT_DIR)/build/$(PROJECT)

include $(MK_INCLUDES)

-include $(PACKAGES_DIR)/packages.mk

