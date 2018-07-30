
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk

TB=wb_uart_tb
TB_MODULES_HDL=wb_uart_tb_hdl
TB_MODULES_HVL=wb_uart_tb_hvl wb_uart_tests_pkg
# TB_MODULES_HDL=wb_if

VL_TB_SRC = $(notdir $(wildcard $(OC_WB_IP)/ve/wb_uart/tb/vl/*.cpp))
SRC_DIRS += $(OC_WB_IP)/ve/wb_uart/tb/vl
VL_TB_OBJS_LIBS += libvl_tb.o


include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk

$(VL_TB_SRC) : vl_translate.d

libvl_tb.o : $(VL_TB_SRC:.cpp=.o)
	$(Q)$(LD) -r -o $@ $(VL_TB_SRC:.cpp=.o)

	