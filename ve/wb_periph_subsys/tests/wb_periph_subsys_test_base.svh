
class wb_periph_subsys_test_base extends uvm_test;
	
	`uvm_component_utils(wb_periph_subsys_test_base)
	
	wb_periph_subsys_env				m_env;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = wb_periph_subsys_env::type_id::create("m_env", this);
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this, "Initialization");
		// Initialize all devices
		uvmdev_mgr::init();
		
		// Initialize the ISR
		m_env.m_dev_isr.init_isr();
		
		// Run a simple DMA test
		begin
			wb_dma_dev dma;
			uvmdev_if dma_dev = uvmdev_mgr::get(0);
			
			if (!$cast(dma, dma_dev)) begin
				`uvm_fatal(get_name(), "Failed to cast to dma");
			end
			
			dma.set_channel_mode(0, 1, 0); // Configure Rx channel
			dma.set_channel_mode(1, 1, 0); // Configure Tx channel

			// Transfer 16 bytes to the UART
			dma.mem2dev_transfer(1, 
					'h1000_0000,
					'h0000_0400,
					128);
			
//			dma.mem2mem_transfer(
//					0,
//					'h1000_0000, 
//					'h1000_1000, 
//					64);
//			
//			fork
//			dma.mem2mem_transfer(
//					0,
//					'h1000_0000, 
//					'h1000_0100, 
//					64);
//			dma.mem2mem_transfer(
//					1,
//					'h1000_0200, 
//					'h1000_0300, 
//					64);
//			join
		end
		phase.drop_objection(this, "Initialization");
	endtask

	/**
	 * Function: report_phase
	 *
	 * Override from class 
	 */
	virtual function void report_phase(input uvm_phase phase);
		string testname;
		uvm_report_server rsvr = get_report_server();
		int n_errors = rsvr.get_severity_count(UVM_ERROR);
		int n_fatal = rsvr.get_severity_count(UVM_FATAL);

		if (!$value$plusargs("TESTNAME=%s", testname)) begin
			`uvm_fatal(get_name(), "+TESTNAME not set");
		end
		
		if (n_errors == 0 && n_fatal == 0) begin
			$display("PASS: %0s", testname);
		end else begin
			$display("FAIL: %0s errors=%0d fatal=%0d", 
					testname, n_errors, n_fatal);
		end
	endfunction
	
endclass

