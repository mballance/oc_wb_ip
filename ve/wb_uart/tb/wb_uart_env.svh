
class wb_uart_env extends uvm_env;
	`uvm_component_utils(wb_uart_env)
	
	class handshake_subscriber extends uvm_subscriber #(event_seq_item);
		`uvm_component_utils(handshake_subscriber)
		
		wb_uart_env				m_env;
		mailbox #(int unsigned)	m_mb = new();
		
		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction
		
		virtual function void write(event_seq_item t);
			void'(m_mb.try_put(t.m_value));
		endfunction

		virtual task run_phase(uvm_phase phase);
			int unsigned value;
			forever begin
				m_mb.get(value);
				m_env.m_uart_dev.set_hw_handshake(value);
			end
		endtask
		
	endclass
	
	typedef wb_master_agent #(32, 32) wb_master_agent_t;
	
	wb_master_agent_t				m_master_agent;
	event_agent						m_irq_agent;
	event_agent						m_handshake_agent;
	handshake_subscriber			m_handshake_sub;
	uvmdev_simple_mem				m_mem;
	wb_uart_reg_block				m_regs;
	wb_uart_dev						m_uart_dev;
	wb_master_reg_adapter #(32, 32)	m_reg_adapter;
	wb_uart_isr						m_uart_isr;
	uart_serial_agent				m_serial_agent;
	uart_agent_dev					m_uart_agent_dev;

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
		
		m_master_agent = wb_master_agent_t::type_id::create("m_master_agent", this);
		
		m_irq_agent = event_agent::type_id::create("m_irq_agent", this);
		
		m_handshake_agent = event_agent::type_id::create("m_handshake_agent", this);
		m_handshake_sub = handshake_subscriber::type_id::create("m_handshake_sub", this);
		m_handshake_sub.m_env = this;
		
		m_regs = wb_uart_reg_block::type_id::create("m_regs");
		m_regs.build();
	
		m_reg_adapter = wb_master_reg_adapter #(32, 32)::type_id::create("m_reg_adapter");
		
		m_uart_isr = wb_uart_isr::type_id::create("m_uart_isr", this);
		
		m_serial_agent = uart_serial_agent::type_id::create("m_serial_agent", this);

		// Create a simple memory model
		m_mem = new('h0000_0000, 'h0000_FFFF);
		
		uvmdev_mgr::set_mem_if(m_mem);
		
		m_uart_dev = wb_uart_dev::type_id::create("m_uart_dev");
		m_uart_isr.set_irq_listener(0, m_uart_dev);
			
		uvmdev_mgr::add(0, m_uart_dev, m_regs);
		
		m_uart_agent_dev = uart_agent_dev::type_id::create("m_uart_agent_dev");
		uvmdev_mgr::add(1, m_uart_agent_dev, m_serial_agent);
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		
		m_regs.default_map.set_sequencer(m_master_agent.m_seqr, m_reg_adapter);
		m_regs.default_map.set_auto_predict(1);
	
		m_handshake_agent.m_mon_out_ap.connect(m_handshake_sub.analysis_export);
		m_irq_agent.m_mon_out_ap.connect(m_uart_isr.analysis_export);
		
		
	endfunction
	
	
endclass
