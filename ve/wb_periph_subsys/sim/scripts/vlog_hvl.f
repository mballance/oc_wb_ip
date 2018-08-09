
+incdir+${OC_WB_IP}/ve/wb_periph_subsys/tb
+incdir+${OC_WB_IP}/ve/wb_periph_subsys/tests

-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/wb/uvm/uvm.f
-f ${SV_BFMS}/uart/uvm/uvm.f
-f ${SV_BFMS}/event/uvm/uvm.f


-f ${OC_WB_IP}/ve/wb_dma/tb/wb_dma_regs/wb_dma_regs.f
-f ${OC_WB_IP}/ve/wb_uart/tb/wb_uart_regs/wb_uart_regs.f
-f ${OC_WB_IP}/ve/wb_simple_pic/tb/wb_simple_pic_regs/wb_simple_pic_regs.f

-f ${UVMDEV}/src/uvmdev.f
-f ${OC_WB_IP}/ve/wb_dma/tb/wb_dma_dev/wb_dma_dev.f
-f ${OC_WB_IP}/ve/wb_simple_pic/tb/wb_simple_pic_dev/wb_simple_pic_dev.f
-f ${OC_WB_IP}/ve/wb_uart/tb/wb_uart_dev/wb_uart_dev.f


-f ${OC_WB_IP}/ve/wb_periph_subsys/tb/wb_periph_subsys_regs/wb_periph_subsys_regs.f

${OC_WB_IP}/ve/wb_periph_subsys/tb/wb_periph_subsys_env_pkg.sv

${OC_WB_IP}/ve/wb_periph_subsys/tests/wb_periph_subsys_tests_pkg.sv

${OC_WB_IP}/ve/wb_periph_subsys/tb/wb_periph_subsys_tb_hvl.sv


