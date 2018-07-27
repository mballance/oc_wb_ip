
-F ./wb_dma/fw/fw.F
-f ./wb_dma/rtl/verilog/rtl.f
-f ./wb_uart/rtl.f
./wb_periph_subsys/wb_periph_subsys.sv
-f ${OC_WB_IP}/rtl/wb_dma/rtl/verilog/rtl.f
-F ${STD_PROTOCOL_IF}/sve.F
-F ${WB_SYS_IP}/sve.F

