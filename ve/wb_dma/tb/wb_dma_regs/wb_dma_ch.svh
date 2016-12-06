/****************************************************************************
 * wb_dma_ch.svh
 ****************************************************************************/

/**
 * Class: wb_dma_ch
 * 
 * TODO: Add class documentation
 */
class wb_dma_ch extends uvm_object;
	`uvm_object_utils(wb_dma_ch)
		
	wb_dma_ch_csr			CSR;
	wb_dma_ch_sz			SZ;
	wb_dma_ch_adr			A0;
	wb_dma_ch_adr_mask		AM0;
	wb_dma_ch_adr			A1;
	wb_dma_ch_adr_mask		AM1;
	wb_dma_ch_adr			DESC;
		
	// TODO: SWPTR
		
	function void build();
		CSR = wb_dma_ch_csr::type_id::create("CSR");
		CSR.build();
		SZ = wb_dma_ch_sz::type_id::create("SZ");
		SZ.build();
		A0 = wb_dma_ch_adr::type_id::create("A0");
		A0.build();
		AM0 = wb_dma_ch_adr_mask::type_id::create("AM0");
		AM0.build();
		A1 = wb_dma_ch_adr::type_id::create("A1");
		A1.build();
		AM1 = wb_dma_ch_adr_mask::type_id::create("AM1");
		AM1.build();
		DESC = wb_dma_ch_adr::type_id::create("DESC");
		DESC.build();
	endfunction
		
	function void configure(uvm_reg_block p, int i);
		CSR.configure(p, null, $psprintf("CH%0d_CSR", i));
		SZ.configure(p, null, $psprintf("CH%0d_SZ", i));
		A0.configure(p, null, $psprintf("CH%0d_A0", i));
		AM0.configure(p, null, $psprintf("CH%0d_AM0", i));
		A1.configure(p, null, $psprintf("CH%0d_A1", i));
		AM1.configure(p, null, $psprintf("CH%0d_AM1", i));
		DESC.configure(p, null, $psprintf("CH%0d_DESC", i));
	endfunction
endclass 
 

