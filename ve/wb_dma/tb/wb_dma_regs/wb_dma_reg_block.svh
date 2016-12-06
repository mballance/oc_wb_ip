/****************************************************************************
 * wb_dma_reg_block.svh
 ****************************************************************************/

/**
 * Class: wb_dma_reg_block
 * 
 * TODO: Add class documentation
 */
class wb_dma_reg_block extends uvm_reg_block;
	`uvm_object_utils(wb_dma_reg_block)
		
	semaphore			sem;
		
	// Registers
	wb_dma_csr			csr;
		
	wb_dma_int_msk		int_msk_a;
	wb_dma_int_msk		int_msk_b;
		
	wb_dma_int_src		int_src_a;
	wb_dma_int_src		int_src_b;
		
	wb_dma_ch			ch[31];
		
	uvm_reg_map			dma_map;
		
	virtual function void build();
		csr = wb_dma_csr::type_id::create("csr");
		csr.configure(this, null, "CSR");
		csr.build();
			
		int_msk_a = wb_dma_int_msk::type_id::create("int_msk_a");
		int_msk_a.build();
		int_msk_a.configure(this, null, "INT_MSK_A");
			
		int_msk_b = wb_dma_int_msk::type_id::create("int_msk_b");
		int_msk_b.build();
		int_msk_b.configure(this, null, "INT_MSK_B");
			
		int_src_a = wb_dma_int_src::type_id::create("int_src_a");
		int_src_a.build();
		int_src_a.configure(this, null, "INT_SRC_A");
			
		int_src_b = wb_dma_int_src::type_id::create("int_src_b");
		int_src_b.build();
		int_src_b.configure(this, null, "INT_SRC_B");
			
		for (int i=0; i<=30; i++) begin
			ch[i] = wb_dma_ch::type_id::create($psprintf("CH%0d", i));
			ch[i].build();
			ch[i].configure(this, i);
		end
			
		// Specify a default map
		default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		default_map.add_reg(csr, 16'h0000, "RW");
		default_map.add_reg(int_msk_a, 16'h0004, "RW");
		default_map.add_reg(int_msk_b, 16'h0008, "RW");
		default_map.add_reg(int_src_a, 16'h000C, "RW");
		default_map.add_reg(int_src_b, 16'h0010, "RW");
			
		for (int i=0; i<=30; i++) begin
			default_map.add_reg(ch[i].CSR, 16'h0040+(i*'h20)+0, "RW");
			default_map.add_reg(ch[i].SZ, 16'h0040+(i*'h20)+4, "RW");
			default_map.add_reg(ch[i].A0, 16'h0040+(i*'h20)+8, "RW");
			default_map.add_reg(ch[i].AM0, 16'h0040+(i*'h20)+12, "RW");
			default_map.add_reg(ch[i].A1, 16'h0040+(i*'h20)+16, "RW");
			default_map.add_reg(ch[i].AM1, 16'h0040+(i*'h20)+20, "RW");
			default_map.add_reg(ch[i].DESC, 16'h0040+(i*'h20)+24, "RW");
		end
			
	endfunction
		
endclass
 


