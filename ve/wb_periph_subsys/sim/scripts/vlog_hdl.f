
+incdir+${SIM_DIR_A}/../tb
+incdir+${SIM_DIR_A}/../tests

${OC_WB_IP}/rtl/wb_periph_subsys/wb_periph_subsys.sv

-f ${WB_SYS_IP}/rtl/rtl.f
-f ${OC_WB_IP}/rtl/simple_pic/rtl/rtl.f
-f ${OC_WB_IP}/rtl/wb_uart/rtl.f
-f ${OC_WB_IP}/rtl/wb_dma/rtl/verilog/rtl.f
-f ${STD_PROTOCOL_IF}/rtl/memory/memory.f
-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f

-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
-f ${SV_BFMS}/wb/wb.f
-f ${SV_BFMS}/uart/sv.f

+define+GENERIC_SRAM_BYTE_EN_BFM_NAME=generic_sram_byte_en
-f ${SV_BFMS}/generic_sram_byte_en/sv.f

${WB_SYS_IP}/rtl/wb_sram/wb_sram.sv

${WB_SYS_IP}/rtl/wb_sram_bridges/wb_generic_byte_en_sram_bridge.sv

${SIM_DIR_A}/../tb/wb_periph_subsys_tb_hdl.sv


