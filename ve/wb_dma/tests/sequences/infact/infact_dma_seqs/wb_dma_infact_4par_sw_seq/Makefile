#**********************************************************************
#*           Makefile for test module wb_dma_infact_4par_sw_seq
#*
#* Copyright 2008 Mentor Graphics Corporation. All Rights Reserved
#*
#* Created with inFact 2016.10.6.x2016120901
#**********************************************************************

TOPDIR=..
include $(TOPDIR)/common/common_defs.mk
-include ./defs.mk


all: $(ALL_TARGETS)

generate : $(GENERATE_TARGETS)

build : $(BUILD_TARGETS)

gen-src : $(GEN_SRC_TARGETS)

gen-bin : $(GEN_BIN_TARGETS)

lib : $(LIB_TARGETS)

clean :
	rm -rf $(CLEAN_FILES)

clean-all : clean
	rm -rf $(CLEAN_ALL_FILES)
	touch *.tmd

# Update the mk files from information in the .tmd file
./rules.mk ./defs.mk :: wb_dma_infact_4par_sw_seq.tmd
	$(TMD2MAKEFILE) wb_dma_infact_4par_sw_seq.tmd

Makefile :: ./rules.mk ./defs.mk

include $(TOPDIR)/common/common_rules.mk
-include ./rules.mk

	
