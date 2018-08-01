
+incdir+${SIM_DIR_A}/../tb
+incdir+${SIM_DIR_A}/../tests

+incdir+${BUILD_DIR}/infact_dma_seqs
+incdir+${BUILD_DIR}/qso

-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
-f ${OC_WB_IP}/rtl/rtl.f
-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/api/sv/sv_dpi.f
-f ${SV_BFMS}/wb/wb.f
-f ${SV_BFMS}/wb/uvm/uvm.f

-f ${UVMDEV}/src/uvmdev.f

${OC_WB_IP}/rtl/wb_dma/fw/wb_dma_fw_pkg.sv

-F ${SIM_DIR_A}/../tb/tb.F

-F ${SIM_DIR_A}/../tests/tests.F

${SIM_DIR_A}/../tb/wb_dma_tb.sv


