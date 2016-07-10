/****************************************************************************
 * wb_uart16550_drv_pkg.sv
 ****************************************************************************/

/**
 * Package: wb_uart16550_drv_pkg
 * 
 * TODO: Add package documentation
 */
package wb_uart16550_drv_pkg;
	
	typedef int unsigned wb_uart16550_drv_t;

	import "DPI-C" context _wb_uart16550_drv_init=task wb_uart16550_drv_init(
			output wb_uart16550_drv_t		drv,
			input int unsigned				base,
			input shortint unsigned			divisor
			);
	
	import "DPI-C" context function void wb_uart16550_drv_setflags(
			input wb_uart16550_drv_t		drv,
			input int unsigned				flags);
	
	import "DPI-C" context function void wb_uart16550_drv_clrflags(
			input wb_uart16550_drv_t		drv,
			input int unsigned				flags);
	
	import "DPI-C" context _wb_uart16550_drv_write=task wb_uart16550_drv_write(
			input wb_uart16550_drv_t		drv,
			input byte unsigned				data[256],
			input int unsigned				sz,
			output int 						ret);
	
	import "DPI-C" context _wb_uart16550_drv_read=task wb_uart16550_drv_read(
			input wb_uart16550_drv_t		drv,
			output byte unsigned			data[256],
			input int unsigned				sz,
			output int 						ret);
	

endpackage


