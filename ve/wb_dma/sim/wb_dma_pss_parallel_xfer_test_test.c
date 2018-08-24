/****************************************************************************
 * wb_dma_pss_parallel_xfer_test_test.c
 ****************************************************************************/
#include "wb_dma_pss_parallel_xfer_test_test.h"

// User Data

void wb_dma_pss_parallel_xfer_test_test(void *ud) {
    queue_dma_single_transfer(
			0, 8, 63, 1, 0x7469,
			1, 0x2fc4);
		
    queue_dma_single_transfer(
			0, 19, 0xa44e, 0, 0x3085,
			1, 4);
		
    queue_dma_single_transfer(
			0, 10, 0x3081, 0, 8,
			1, 4);
		
    queue_dma_single_transfer(
			0, 16, 0xa703, 1, 0x320f,
			1, 0x4240);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 29, 0x9fd2, 1, 0xfd4d,
			0, 0x5584);
		
    queue_dma_single_transfer(
			0, 8, 0x8cba, 0, 0x9d4f,
			1, 4);
		
    queue_dma_single_transfer(
			0, 10, 0x5071, 1, 0x1431,
			1, 0x3c1c);
		
    queue_dma_single_transfer(
			0, 11, 0x505e, 0, 0x8cb2,
			1, 4);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 22, 1, 1, 0xf7ff,
			0, 0x5b38);
		
    queue_dma_single_transfer(
			0, 21, 0xccfe, 1, 0xe27e,
			1, 0x1580);
		
    queue_dma_single_transfer(
			0, 30, 0xa004, 1, 0x5b3a,
			1, 0x2cf4);
		
    queue_dma_single_transfer(
			0, 26, 0x882e, 1, 0xccfa,
			0, 0x1168);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 7, 0xb10f, 1, 0x3c38,
			1, 0x4db0);
		
    queue_dma_single_transfer(
			0, 25, 0x31c3, 1, 0x2752,
			1, 0xa70);
		
    queue_dma_single_transfer(
			0, 22, 0x89e9, 1, 49,
			1, 0x2714);
		
    queue_dma_single_transfer(
			0, 23, 0x3c33, 0, 0x3c37,
			1, 4);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 1, 0x2a5c, 0, 0x1ca5,
			1, 4);
		
    queue_dma_single_transfer(
			0, 8, 0x1bdd, 0, 0x19a5,
			1, 4);
		
    queue_dma_single_transfer(
			0, 2, 0x2ae6, 1, 0x1a23,
			0, 0xd4ec);
		
    queue_dma_single_transfer(
			0, 0, 0x917, 1, 0x1ad2,
			0, 0x1074);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 15, 0xb76d, 0, 32,
			1, 4);
		
    queue_dma_single_transfer(
			0, 24, 196, 1, 0x5b95,
			1, 0x5a38);
		
    queue_dma_single_transfer(
			0, 5, 0xb895, 1, 28,
			0, 0x4728);
		
    queue_dma_single_transfer(
			0, 10, 0xb787, 1, 186,
			0, 220);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 30, 0, 1, 0x7848,
			1, 0x7844);
		
    queue_dma_single_transfer(
			0, 29, 0xf250, 0, 0xf096,
			1, 4);
		
    queue_dma_single_transfer(
			0, 25, 0x7844, 0, 0xfc6c,
			1, 4);
		
    queue_dma_single_transfer(
			0, 27, 0xf291, 1, 0xf08c,
			0, 0x834);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 15, 0xfae5, 0, 0xfaf9,
			1, 4);
		
    queue_dma_single_transfer(
			0, 5, 0x1225, 1, 0xfffc,
			0, 0xdc34);
		
    queue_dma_single_transfer(
			0, 1, 82, 1, 0xfafc,
			1, 0x500);
		
    queue_dma_single_transfer(
			0, 3, 0x581, 1, 0xee59,
			1, 0xc88);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 4, 0x12df, 1, 0x6eef,
			1, 0x29f8);
		
    queue_dma_single_transfer(
			0, 25, 0x63fa, 1, 0x3cd9,
			0, 908);
		
    queue_dma_single_transfer(
			0, 7, 58, 1, 0xb51d,
			0, 0x12a4);
		
    queue_dma_single_transfer(
			0, 23, 0x6854, 0, 0x6e16,
			1, 4);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 30, 0x959c, 1, 0x5526,
			0, 0x6a60);
		
    queue_dma_single_transfer(
			0, 29, 1, 1, 0xfffc,
			0, 0x5450);
		
    queue_dma_single_transfer(
			0, 28, 0x552a, 1, 0x958f,
			0, 0x4064);
		
    queue_dma_single_transfer(
			0, 23, 0x5452, 1, 0x5522,
			0, 208);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 0, 571, 1, 566,
			0, 0x3634);
		
    queue_dma_single_transfer(
			0, 2, 0x38b0, 1, 0x387b,
			0, 0xc6d4);
		
    queue_dma_single_transfer(
			0, 26, 0x387f, 0, 570,
			1, 4);
		
    queue_dma_single_transfer(
			0, 1, 0x386f, 0, 0x388b,
			1, 4);
		
    wait_threads();
    queue_dma_single_transfer(
			0, 28, 0x7f8b, 0, 0xfffa,
			1, 4);
		
    queue_dma_single_transfer(
			0, 24, 0x5d2, 1, 0x8141,
			1, 0x511c);
		
    queue_dma_single_transfer(
			0, 25, 0xe1fe, 1, 0xfffc,
			0, 0x1d74);
		
    queue_dma_single_transfer(
			0, 26, 0x5d8b, 1, 0xd25d,
			1, 0xfa0);
		
    wait_threads();
}
