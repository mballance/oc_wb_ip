
+incdir+./tb
+incdir+./tests
+incdir+./tests/sequences

-f ./tb/wb_uart_regs/wb_uart_regs.f
-f ./tb/wb_uart_dev/wb_uart_dev.f

./tb/wb_uart_env_pkg.sv
./tests/sequences/wb_uart_sequences_pkg.sv
./tests/wb_uart_tests_pkg.sv
./tb/wb_uart_tb_hdl.sv
./tb/wb_uart_tb_hvl.sv
