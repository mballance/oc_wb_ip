
class wb_uart_handshake_tx_test extends wb_uart_test_base;
	
	`uvm_component_utils(wb_uart_handshake_tx_test)
	
	/****************************************************************
	 * Data Fields
	 ****************************************************************/
	
	/****************************************************************
	 * new()
	 ****************************************************************/
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	/****************************************************************
	 * build_phase()
	 ****************************************************************/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	/****************************************************************
	 * connect_phase()
	 ****************************************************************/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);

		// Initialize everything
		super.run_phase(phase);
	
		phase.raise_objection(this, "Main");
	
		for (int i=0; i<100; i++) begin
			m_env.m_uart_dev.tx_handshake(i+1);
		end
		
		phase.drop_objection(this, "Main");

	endtask
	
endclass



