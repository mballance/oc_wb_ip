
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk
# MK_INCLUDES += $(ROCKET_SOC)/mkfiles/rocket_soc.mk

TB=wb_uart_tb
TB_MODULES_HDL=wb_uart_tb_hdl
TB_MODULES_HVL=wb_uart_tb_hvl wb_uart_tests_pkg
# TB_MODULES_HDL=wb_if

VL_TB_SRC_FULL = $(wildcard $(OC_WB_IP)/ve/wb_uart/tb/vl/*.cpp)
VL_TB_SRC = $(notdir $(VL_TB_SRC_FULL))
SRC_DIRS += $(OC_WB_IP)/ve/wb_uart/tb/vl
VL_TB_OBJS_LIBS += libvl_tb.o

$(VL_TB_SRC_FULL) : vl_translate.d

include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk


libvl_tb.o : $(VL_TB_SRC:.cpp=.o)
	$(Q)$(LD) -r -o $@ $(VL_TB_SRC:.cpp=.o)

include $(PACKAGES_DIR)/packages.mk
	