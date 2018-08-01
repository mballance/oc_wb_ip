
+incdir+${OC_WB_IP}/ve/wb_periph_subsys/tb
+incdir+${OC_WB_IP}/ve/wb_periph_subsys/tests

-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/wb/uvm/uvm.f
-f ${SV_BFMS}/uart/uvm/uvm.f
-f ${SV_BFMS}/event/uvm/uvm.f

${OC_WB_IP}/ve/wb_periph_subsys/tb/wb_periph_subsys_env_pkg.sv

${OC_WB_IP}/ve/wb_periph_subsys/tests/wb_periph_subsys_tests_pkg.sv

${OC_WB_IP}/ve/wb_periph_subsys/tb/wb_periph_subsys_tb_hvl.sv


