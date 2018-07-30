#include <stdio.h>
#include <stdint.h>
#include "Vwb_uart_tb_hdl.h"

bool reset = false;
bool in_flight = false;
void *scope = 0;

unsigned int wb_master_bfm_register(const char *path) {
	fprintf(stdout, "wb_master_bfm_register %s\n", path);
	scope = svGetScope();
	return 0;
}

int wb_master_bfm_response(
		unsigned int		id,
		unsigned char		ERR) {
	fprintf(stdout, "wb_master_bfm_response %d\n", ERR);
	in_flight = false;
	return 0;
}

int wb_master_bfm_reset(unsigned int id) {
	fprintf(stdout, "wb_master_bfm_reset\n");
	reset = true;
	return 0;
}

int main(int argc, char **argv) {
	fprintf(stdout, "Hello from wb_uart_main\n");

	Vwb_uart_tb_hdl *top = new Vwb_uart_tb_hdl();

	for (uint32_t i=0; i<1000; i++) {
		// Toggle the clock
		top->clk = !top->clk;

		if (reset && !in_flight) {
			svSetScope(scope);
			fprintf(stdout, "--> request\n");
			wb_master_bfm_request(0x1000, 0, 0, 0xF, 1);
			fprintf(stdout, "<-- request\n");
			in_flight = true;
		}

		top->eval();
	}

	return 0;
}
