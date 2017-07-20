#<banner,gen>
#****************************************************************************
# inFact iVC Project Top-Level Makefile
# 
# Copyright 2008 Mentor Graphics. All Rights Reserved
#****************************************************************************
#</banner>
TOPDIR=.
include $(TOPDIR)/common/common_defs.mk

#<toplevel_targets,gen>

# Set default values for project .ini file
ifeq (,$(INFACT_INI_NAME))
    INFACT_INI_NAME := $(shell basename `pwd`)
endif

ifeq (,$(INFACT_INI_ROOT))
    INFACT_INI_ROOT=INFACT_INI_DIR
endif

GENERATE_TARGETS = gen-src gen-bin
BUILD_TARGETS    = lib 
ALL_TARGETS      = $(GENERATE_TARGETS) $(BUILD_TARGETS) $(INFACT_INI_NAME).ini

#--------------------------------------------------------------------
#- all
#--------------------------------------------------------------------
all : $(ALL_TARGETS)
	
generate : $(GENERATE_TARGETS)

build : $(BUILD_TARGETS)

gen-src :
	$(BUILD_SUBDIRS)
	
gen-bin :
	$(BUILD_SUBDIRS)

lib :
	$(BUILD_SUBDIRS)

.PHONY: $(INFACT_INI_NAME).ini

$(INFACT_INI_NAME).ini :
	@echo "# $(INFACT_INI_NAME).ini" > $@
	@for tid in `find . -maxdepth 2 -name '*.tid'`; do \
            tid=`echo $$tid | sed -e 's@^\.@@'` ; \
            echo "TIDFILE: \$${$(INFACT_INI_ROOT)}$$tid" >> $@ ; \
        done


#--------------------------------------------------------------------
#- clean
#- Removes object files, but does not remove generated source files
#--------------------------------------------------------------------
clean :
	@rm -rf $(INFACT_INI_NAME).ini
	$(BUILD_SUBDIRS)

#--------------------------------------------------------------------
#- clean-all
#- Removes object files and generated source
#--------------------------------------------------------------------
clean-all : 
	@rm -rf $(INFACT_INI_NAME).ini
	$(BUILD_SUBDIRS)
	
#</toplevel_targets>


include $(TOPDIR)/common/common_rules.mk

