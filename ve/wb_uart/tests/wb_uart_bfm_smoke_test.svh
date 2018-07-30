
class wb_uart_bfm_smoke_test extends wb_uart_test_base;
	
	`uvm_component_utils(wb_uart_bfm_smoke_test)
	
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
		sv_bfms_rw_api_if	api = m_env.m_master_agent.get_api();
		bit[7:0] data;
	
		phase.raise_objection(this, "Main");
		api.read32('h0000_000C, data); // Read LCR
		data[7] = 1; // enable DLB
		api.write32('h0000_000C, data);
		
		api.write32('h0000_0004, 0);
		api.write32('h0000_0000, 14); // DL LSB 14=115200
		
		data[7] = 0;
		api.write32('h0000_000C, data);

		// Fill up the FIFO
		for (int i=0; i<16; i++) begin
			api.write32('h0000_0000, i+1);
		end

		for (int i=0; i<4; i++) begin
			do begin
				api.read32('h0000_0014, data); // read LSR
			end while (data[6] == 0);
			
			api.write32('h0000_0000, i+1);
		end
		
		phase.drop_objection(this, "Main");

	endtask
	
endclass



