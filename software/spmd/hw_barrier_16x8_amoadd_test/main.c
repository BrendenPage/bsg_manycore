
#include "bsg_manycore.h"
#include "bsg_set_tile_x_y.h"
#include "bsg_manycore_atomic.h"
#include "bsg_hw_barrier.h"
#include "bsg_hw_barrier_config.h"

#define N 10

int data[bsg_tiles_X*bsg_tiles_Y] __attribute__ ((section (".dram"))) = {0};

int main()
{
  bsg_set_tile_x_y();

  // config hw barrier
  int barcfg = barcfg_16x8[__bsg_id];
  asm volatile ("csrrw x0, 0xfc1, %0" : : "r" (barcfg));

  for (int i = 0; i < N; i++) {
    // do updates using amoadd
    bsg_amoadd_aq(&data[(__bsg_id+i)%(bsg_tiles_X*bsg_tiles_Y)], 1);
    // fence before barrier
    bsg_fence();
    // join barrier
    bsg_barsend();
    // wait for barrier to complete
    bsg_barrecv();
  }

  if (__bsg_id == 0) {
    // validate
    for (int i = 0; i < bsg_tiles_X*bsg_tiles_Y; i++) {
      if (data[i] != N) {
        bsg_fail();
        bsg_wait_while(1);
      }
    }
    bsg_finish();
  }
  
  bsg_wait_while(1);
}

