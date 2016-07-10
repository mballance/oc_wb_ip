
class wb_uart16550_simple_fw_rx_test extends wb_uart16550_test_base;
	
	`uvm_component_utils(wb_uart16550_simple_fw_rx_test)
	
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

	byte unsigned				rx_data[$];

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);
		phase.raise_objection(this, "Main");
		fork
			begin
				wb_uart16550_drv_t 	drv;
				byte unsigned		data[256];
				int					read_ret;
				int 				tot_sz = 0;
				
				wb_uart16550_drv_init(drv, 0, 162/8);
				
				do begin
					wb_uart16550_drv_read(drv, data, 1, read_ret);
					
					for (int i=0; i<read_ret; i++) begin
						rx_data.push_back(data[i]);
					end
					
					tot_sz += read_ret;
				end while (tot_sz < 4);
			end
			begin
				uart_serial_tx_seq seq = uart_serial_tx_seq::type_id::create("seq");
				
				seq.data.push_back('h55);
				seq.data.push_back('hAA);
				seq.data.push_back('h01);
				seq.data.push_back('h02);
				
				seq.start(m_env.uart_agent.m_seqr);
			end
		join
	
		
		for (int i=0; i<rx_data.size(); i++) begin
			$display("rx_data[%0d] = 'h%02h", i, rx_data[i]);
		end
		
		phase.drop_objection(this, "Main");
	endtask
	
endclass



