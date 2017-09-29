
OC_WB_IP_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

OC_WB_IP_LIB := oc_wb_ip_lib.jar
OC_WB_IP_LIBS = $(OC_WB_IP_LIB) $(STD_PROTOCOL_IF_LIB) $(CHISELLIB_JAR)
OC_WB_IP_SRC := \
  $(wildcard $(OC_WB_IP_SRC_DIR)/oc_wb_ip/wb_dma/*.scala) \
  $(wildcard $(OC_WB_IP_SRC_DIR)/oc_wb_ip/wb_uart/*.scala)

else # Rules

$(OC_WB_IP_LIB) : $(OC_WB_IP_SRC) $(STD_PROTOCOL_IF_LIB) $(CHISELLIB_JAR)
	$(Q)$(CHISELC) -o $@ $(OC_WB_IP_SRC) -L$(CHISELLIB_JAR) -L$(STD_PROTOCOL_IF_LIB)

endif

