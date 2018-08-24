
+incdir+${OC_WB_IP}/ve/wb_uart/tb
+incdir+${OC_WB_IP}/ve/wb_uart/tests
+incdir+${OC_WB_IP}/ve/wb_uart/tests/sequences

-f ${UVMDEV}/src/uvmdev.f

-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/wb/uvm/uvm.f
-f ${SV_BFMS}/event/uvm/uvm.f
-f ${SV_BFMS}/uart/uvm/uvm.f
-f ${SV_BFMS}/uart/uvm/uart_agent_dev/uart_agent_dev.f


-f ${OC_WB_IP}/ve/wb_uart/tb/wb_uart_regs/wb_uart_regs.f
-f ${OC_WB_IP}/ve/wb_uart/tb/wb_uart_dev/wb_uart_dev.f

${OC_WB_IP}/ve/wb_uart/tb/wb_uart_env_pkg.sv
${OC_WB_IP}/ve/wb_uart/tests/sequences/wb_uart_sequences_pkg.sv
${OC_WB_IP}/ve/wb_uart/tests/wb_uart_tests_pkg.sv

//-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
//-f ${OC_WB_IP}/rtl/wb_uart/rtl.f
//-f ${SV_BFMS}/wb/wb.f

${OC_WB_IP}/ve/wb_uart/tb/wb_uart_tb_hvl.sv


