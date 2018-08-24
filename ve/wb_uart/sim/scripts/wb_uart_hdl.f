
+incdir+${OC_WB_IP}/ve/wb_uart/tb
+incdir+${OC_WB_IP}/ve/wb_uart/tests

// ${OC_WB_IP}/ve/wb_uart/tb/wb_uart_env_pkg.sv

// ${OC_WB_IP}/ve/wb_uart/tests/wb_uart_tests_pkg.sv

-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
-f ${OC_WB_IP}/rtl/wb_uart/rtl.f
-f ${SV_BFMS}/wb/wb.f
-f ${SV_BFMS}/event/event.f
-f ${SV_BFMS}/uart/sv.f

${OC_WB_IP}/ve/wb_uart/tb/wb_uart_tb_hdl.sv


