
class wb_periph_subsys_env extends uvm_env;
	`uvm_component_utils(wb_periph_subsys_env)
	
	parameter int WB_ADDR_WIDTH = 32;
	parameter int WB_DATA_WIDTH = 32;
	
	typedef wb_master_agent #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_agent_t;
	typedef wb_master_reg_adapter #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_reg_adapter_t;
	
	
	wb_master_agent_t				m_wb_agent;
	uart_serial_agent				m_uart_agent;
	event_agent						m_event_agent;
	wb_master_reg_adapter_t			m_reg_adapter;
	wb_periph_subsys_regblk			m_regs;
	wb_periph_subsys_isr			m_dev_isr;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	/**
	 * Function: build_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void build_phase(input uvm_phase phase);
		super.build_phase(phase);
		
		m_wb_agent = wb_master_agent_t::type_id::create("m_wb_agent", this);
		m_uart_agent = uart_serial_agent::type_id::create("m_uart_agent", this);
		m_event_agent = event_agent::type_id::create("m_event_agent", this);
		
		m_dev_isr = wb_periph_subsys_isr::type_id::create("m_dev_isr", this);
		
		m_regs = wb_periph_subsys_regblk::type_id::create("m_regs");
		m_regs.build();
		
		m_reg_adapter = wb_master_reg_adapter_t::type_id::create("m_reg_adapter");
		
		// Create the devices
		begin
			wb_dma_dev dma = new(m_regs.m_dma);
			wb_simple_pic_dev pic = new("pic", m_regs.m_pic);
			wb_uart_dev uart = wb_uart_dev::type_id::create("uart");
		
			uart.set_regs(m_regs.m_uart);
			
			uvmdev_mgr::add(0, dma);
			uvmdev_mgr::add(1, pic);
			uvmdev_mgr::add(2, uart);

			// Provide the subsystem ISR a handle to the PIC
			m_dev_isr.set_pic_dev(pic);
		
			// Connect the dma to the first irq
			m_dev_isr.set_irq_listener(0, dma);
		end
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		
	
		// Connect the Device ISR to the event agent
		m_event_agent.m_mon_out_ap.connect(m_dev_isr.analysis_export);
		
		m_regs.default_map.set_sequencer(m_wb_agent.m_seqr, m_reg_adapter);
		m_regs.default_map.set_auto_predict(1);
	endfunction
	
	
endclass
