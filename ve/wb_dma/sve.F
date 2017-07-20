
+incdir+./tb
+incdir+./tests
+incdir+${UVM_HOME}/src
+define+INFACT
+incdir+${RUNDIR}/wb_dma/qs/infact_imp_proj
+incdir+${RUNDIR}/wb_dma/qs/infact_dma_seqs

${UVM_HOME}/src/uvm_pkg.sv

-F ./tb/tb.F
-F ./tests/tests.F

./tb/wb_dma_tb.sv

