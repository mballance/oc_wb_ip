
class wb_uart_irq_rx_test extends wb_uart_test_base;
	
	`uvm_component_utils(wb_uart_irq_rx_test)
	
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
		byte unsigned data;

		// Initialize everything
		super.run_phase(phase);
	
		phase.raise_objection(this, "Main");

		fork
			begin
				m_env.m_uart_agent_dev.tx_rand_data(1, 10);
			end
			begin
				for (int i=0; i<10; i++) begin
					m_env.m_uart_dev.rx(data);
					$display("UART: data='h%02h", data);
				end
			end
		join
		
		phase.drop_objection(this, "Main");

	endtask
	
endclass



