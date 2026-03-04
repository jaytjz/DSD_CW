#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <system.h>
#include <io.h>
#include <sys/times.h>
#include "altera_msgdma.h"
#include "altera_msgdma_descriptor_regs.h"

#define N_TC1    52
#define N_TC2    2041
#define N_TC3    65281
#define N_TC4    2323
#define RANDSEED 334
#define MAXVAL   255.0f

static float x_buf[N_TC3];

static float sw_fx(float x) {
    return 0.5f * x + x*x*x * cosf((x - 128.0f) / 128.0f);
}

static float sw_sum_ref(float *x, int n) {
    float acc = 0.0f;
    for (int i = 0; i < n; i++)
        acc = acc + sw_fx(x[i]);
    return acc;
}

static void gen_stepped(float *x, int n, float step) {
    x[0] = 0.0f;
    for (int i = 1; i < n; i++)
        x[i] = x[i-1] + step;
}
static void gen_random(float *x, int n) {
    srand(RANDSEED);
    for (int i = 0; i < n; i++)
        x[i] = ((float)rand() / (float)RAND_MAX) * MAXVAL;
}
static void gen_tc1(float *x, int n) { gen_stepped(x, n, 5.0f);          }
static void gen_tc2(float *x, int n) { gen_stepped(x, n, 1.0f / 8.0f);   }
static void gen_tc3(float *x, int n) { gen_stepped(x, n, 1.0f / 256.0f); }
static void gen_tc4(float *x, int n) { (void)n; gen_random(x, N_TC4);    }

static int run_test(alt_msgdma_dev *dma, const char *name,
                    float *x, int n, void (*gen)(float *, int)) {
    printf("\n=== %s (N=%d) ===\n", name, n);

    // Generate vector once - no flush needed (on-chip memory, uncached)
    gen(x, n);
    alt_dcache_flush(x, n * sizeof(float));

    // Build descriptor once
    alt_msgdma_standard_descriptor desc;
    alt_msgdma_construct_standard_mm_to_st_descriptor(
        dma, &desc,
        (alt_u32 *)x,
        n * sizeof(float),
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_SOP_MASK |
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_EOP_MASK
    );

    // Timed loop: clear done, submit, poll
    clock_t total = 0;
    printf("HW timing (10 runs):\n");
    for (int run = 0; run < 10; run++) {
        IOWR_32DIRECT(DMA_F_X_0_BASE, 0, 1);  // clear done
        alt_msgdma_standard_descriptor_async_transfer(dma, &desc);

        volatile uint32_t done = 0;
        int timeout = 0;
        clock_t t0 = times(NULL);
        while (!(done & 1)) {
            done = IORD_32DIRECT(DMA_F_X_0_BASE, 0);
            if (++timeout > 200000000) {
                printf("  TIMEOUT\n");
                return 0;
            }
        }
        clock_t t1 = times(NULL);

        total += t1 - t0;
        printf("  Run %d: %lu ticks\n", run + 1, (unsigned long)(t1 - t0));
    }

    // Read sum from last run
    float hw_sum = 0.0f;
    uint32_t bits = IORD_32DIRECT(DMA_F_X_0_BASE, 4);
    memcpy(&hw_sum, &bits, 4);
    clock_t avg_hw = total / 10;

    // SW reference - sequential float32 to match hardware accumulation order
    clock_t t0       = times(NULL);
    float   sw_sum   = sw_sum_ref(x, n);
    clock_t sw_ticks = times(NULL) - t0;

    float rel_err = fabsf(sw_sum) > 1e-6f
                  ? fabsf(hw_sum - sw_sum) / fabsf(sw_sum)
                  : fabsf(hw_sum - sw_sum);

    printf("HW sum         : %.0f\n", hw_sum);
    printf("SW sum         : %.0f\n", sw_sum);
    printf("Rel error      : %d ppm\n",
           rel_err < 1.0f ? (int)(rel_err * 1e6f) : 999999);
    printf("Avg HW ticks   : %lu\n",  (unsigned long)avg_hw);
    printf("SW ticks       : %lu\n",  (unsigned long)sw_ticks);
    printf("HW speedup     : %.1fx\n",
           avg_hw > 0 ? (float)sw_ticks / (float)avg_hw : 0.0f);
    printf("Result         : %s\n", rel_err < 0.001f ? "PASS" : "FAIL");
    return rel_err < 0.001f;
}

int main(void) {
    printf("=== Task 8: Full F(x) hardware accelerator ===\n");
    printf("F(x) = sum_i f(x_i), f(x)=0.5*x+x^3*cos((x-128)/128)\n\n");

    alt_msgdma_dev *dma = alt_msgdma_open(MSGDMA_0_CSR_NAME);
    if (!dma) { printf("ERROR: cannot open mSGDMA\n"); return 1; }

    int all_pass = 1;
    all_pass &= run_test(dma, "TC1 step=5",     x_buf, N_TC1, gen_tc1);
    all_pass &= run_test(dma, "TC2 step=1/8",   x_buf, N_TC2, gen_tc2);
    all_pass &= run_test(dma, "TC3 step=1/256", x_buf, N_TC3, gen_tc3);
    all_pass &= run_test(dma, "TC4 random",     x_buf, N_TC4, gen_tc4);

    printf("\n%s\n", all_pass ? "ALL TESTS PASSED" : "SOME TESTS FAILED");
    return all_pass ? 0 : 1;
}
