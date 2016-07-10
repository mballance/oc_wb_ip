
-f ${SV_BFMS}/api/sv/sv.f
-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f

-f ${SV_BFMS}/wb/uvm/uvm.f
-f ${SV_BFMS}/wb/wb.f

-f ${SV_BFMS}/uart/uvm/uvm.f
-f ${SV_BFMS}/uart/sv.f

${OC_WB_IP}/rtl/wb_uart16550/fw/wb_uart16550_drv_pkg.sv

-f ${OC_WB_IP}/rtl/wb_uart16550/rtl/rtl.f

+incdir+${OC_WB_IP}/ve/wb_uart16550/tb
+incdir+${OC_WB_IP}/ve/wb_uart16550/tests

${OC_WB_IP}/ve/wb_uart16550/tb/wb_uart16550_env_pkg.sv

${OC_WB_IP}/ve/wb_uart16550/tests/wb_uart16550_tests_pkg.sv

${OC_WB_IP}/ve/wb_uart16550/tb/wb_uart16550_tb.sv


