
OC_WB_IP_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
OC_WB_IP_DIR := $(abspath $(OC_WB_IP_MKFILES_DIR)/..)

OC_WB_IP := $(OC_WB_IP_DIR)
export OC_WB_IP


ifneq (1,$(RULES))

OC_WB_IP_JAR = $(OC_WB_IP_DIR)/lib/oc_wb_ip.jar

OC_WB_IP_DEPS = $(STD_PROTOCOL_IF_JARS) $(CHISELLIB_JARS)

OC_WB_IP_JARS = $(OC_WB_IP_JAR) $(OC_WB_IP_DEPS)

else # Rules


endif

