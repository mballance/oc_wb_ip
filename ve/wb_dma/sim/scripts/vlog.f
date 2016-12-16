
+incdir+${SIM_DIR_A}/../tb
+incdir+${SIM_DIR_A}/../tests

-f ${OC_WB_IP}/rtl/rtl.f
-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/api/sv/dpi.f
-f ${SV_BFMS}/wb/wb.f
-f ${SV_BFMS}/wb/uvm/uvm.f

${OC_WB_IP}/rtl/wb_dma/fw/wb_dma_fw_pkg.sv

-F ${SIM_DIR_A}/../tb/tb.F

-F ${SIM_DIR_A}/../tests/tests.F

${SIM_DIR_A}/../tb/wb_dma_tb.sv


