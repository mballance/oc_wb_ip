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

	import "DPI-C" task wb_uart16550_drv_init(
			output wb_uart16550_drv_t		drv,
			input bit[31:0]					base);


endpackage


