
class wb_uart16550_simple_fw_tx_test extends wb_uart16550_test_base;
	
	`uvm_component_utils(wb_uart16550_simple_fw_tx_test)
	
	uvm_analysis_imp #(uart_serial_seq_item, wb_uart16550_simple_fw_tx_test)
		serial_listener;
	
	bit[7:0]					rx_data[$];
	event						rx_data_ev;
	
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
		
		serial_listener = new("serial_listener", this);
	endfunction

	/****************************************************************
	 * connect_phase()
	 ****************************************************************/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		m_env.uart_agent.m_mon_out_ap.connect(serial_listener);
	endfunction

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);
		wb_uart16550_drv_t drv;
		byte unsigned data[256];
		int ret, err=0;
		
		phase.raise_objection(this, "Main");
//		wb_uart16550_drv_init(drv, 'h0, 162);
		wb_uart16550_drv_init(drv, 'h0, 162/8);
		
		for (int i=0; i<64; i++) begin
			data[i] = i+1;
		end
		
		wb_uart16550_drv_write(drv, data, 64, ret);
		
		if (ret != 64) begin
			`uvm_error("UART", $psprintf("Expect drv_write to return 64; returned %0d", ret));
		end
		
		while (rx_data.size() < 64) begin
			@(rx_data_ev);
		end
		
		$display("Received all data");
		
		for (int i=0; i<64; i++) begin
			if (rx_data[i] != data[i]) begin
				`uvm_error ("UART", $psprintf("@ %0d: Expect %0d, receive %0d",
							i, data[i], rx_data[i]));
				err++;
			end
		end
		
		if (err == 0) begin
			`uvm_info ("UART", "PASS: wb_uart16550_simple_fw_tx_test", UVM_LOW);
		end else begin
			`uvm_info ("UART", 
					$psprintf("FAIL: wb_uart16550_simple_fw_tx_test %0d errors", err), UVM_LOW);
		end
		
		phase.drop_objection(this, "Main");
	endtask
	
	function void write(uart_serial_seq_item t);
		rx_data.push_back(t.data);
		-> rx_data_ev;
	endfunction
	
endclass



