#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <system.h>
#include <io.h>
#include <sys/alt_cache.h>
#include <sys/times.h>
#include "altera_msgdma.h"
#include "altera_msgdma_descriptor_regs.h"

// Task 8: Full F(x) = sum of f(x_i) over vector x, entirely in hardware.
// mSGDMA streams x[] to dma_f_x which computes f(x) per element and
// accumulates.  CPU only times and reads the final result.
//
// dma_f_x MM slave (byte offsets):
//   offset 0 - done (bit 0): write any value to clear; read to poll
//   offset 4 - sum  (IEEE 754 float): valid when done=1

// Test case parameters (coursework spec)
#define N_TC1    52
#define N_TC2    2041
#define N_TC3    65281
#define N_TC4    2323
#define RANDSEED 334
#define MAXVAL   255.0f

// Global buffer - must be in SDRAM for mSGDMA to access
static float x_buf[N_TC3];

// SW reference: f(x) = 0.5*x + x^3 * cos((x-128)/128)
static float sw_fx(float x) {
    return 0.5f * x + x*x*x * cosf((x - 128.0f) / 128.0f);
}

// SW reference sum using double accumulator for accuracy
static float sw_sum_ref(float *x, int n) {
    double acc = 0.0;
    for (int i = 0; i < n; i++)
        acc += (double)sw_fx(x[i]);
    return (float)acc;
}

// Vector generators
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

// Clear done flag, submit DMA, poll for completion, return sum.
// Times only the hardware computation (from DMA submit to done=1).
static int hw_run(alt_msgdma_dev *dma, float *src, int n,
                  float *out_sum, clock_t *out_ticks) {
    // Clear stale done from previous run
    IOWR_32DIRECT(DMA_F_X_0_BASE, 0, 1);

    // Flush CPU cache so mSGDMA reads fresh data from SDRAM
    alt_dcache_flush(src, n * sizeof(float));

    alt_msgdma_standard_descriptor desc;
    alt_msgdma_construct_standard_mm_to_st_descriptor(
        dma, &desc,
        (alt_u32 *)src,
        n * sizeof(float),
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_SOP_MASK |
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_EOP_MASK
    );

    // Start timer then kick off transfer
    clock_t t0 = times(NULL);
    if (alt_msgdma_standard_descriptor_async_transfer(dma, &desc) != 0) {
        printf("  ERROR: descriptor submit failed\n");
        return -1;
    }

    // Poll until done
    volatile uint32_t done = 0;
    int timeout = 0;
    while (!(done & 1)) {
        done = IORD_32DIRECT(DMA_F_X_0_BASE, 0);
        if (++timeout > 200000000) {
            printf("  ERROR: TIMEOUT\n");
            return -1;
        }
    }
    clock_t t1 = times(NULL);

    *out_ticks = t1 - t0;

    // Read result
    uint32_t bits = IORD_32DIRECT(DMA_F_X_0_BASE, 4);
    memcpy(out_sum, &bits, 4);
    return 0;
}

// Run a full test: generate vector, run HW 10x, run SW reference, report.
static int run_test(alt_msgdma_dev *dma, const char *name,
                    float *x, int n, void (*gen)(float *, int)) {
    printf("\n=== %s (N=%d) ===\n", name, n);

    gen(x, n);

    // -- Hardware: 10 timed runs --
    clock_t total_hw_ticks = 0;
    float   hw_sum         = 0.0f;
    printf("HW timing (10 runs):\n");
    for (int run = 0; run < 10; run++) {
        clock_t ticks = 0;
        if (hw_run(dma, x, n, &hw_sum, &ticks) != 0)
            return 0;
        total_hw_ticks += ticks;
        printf("  Run %d: %lu ticks\n", run + 1, (unsigned long)ticks);
    }
    clock_t avg_hw = total_hw_ticks / 10;

    // -- Software reference (single run for accuracy, timed for comparison) --
    clock_t t0 = times(NULL);
    float   sw_sum = sw_sum_ref(x, n);
    clock_t sw_ticks = times(NULL) - t0;

    // -- Accuracy --
    float abs_err = fabsf(hw_sum - sw_sum);
    float rel_err = fabsf(sw_sum) > 1e-6f
                  ? abs_err / fabsf(sw_sum)
                  : abs_err;
    float mse = 0.0f;
    for (int i = 0; i < n; i++) {
        float e = sw_fx(x[i]);           // per-element SW reference
        // we can't get per-element HW; report overall sum MSE proxy instead
        (void)e;
    }

    // Print sums scaled to avoid int overflow
    printf("HW sum /1024   : %ld\n",  (long)(hw_sum  / 1024.0f));
    printf("SW sum /1024   : %ld\n",  (long)(sw_sum  / 1024.0f));
    printf("Rel error      : %d ppm\n",
           rel_err < 1.0f ? (int)(rel_err * 1e6f) : 999999);
    printf("Avg HW ticks   : %lu\n",  (unsigned long)avg_hw);
    printf("SW ticks       : %lu\n",  (unsigned long)sw_ticks);
    printf("HW speedup     : %.1fx\n",
           avg_hw > 0 ? (float)sw_ticks / (float)avg_hw : 0.0f);

    int pass = rel_err < 0.001f;
    printf("Result         : %s\n", pass ? "PASS" : "FAIL");
    return pass;
}

// Wrappers matching void(*)(float*,int) signature
static void gen_tc1(float *x, int n) { gen_stepped(x, n, 5.0f);          }
static void gen_tc2(float *x, int n) { gen_stepped(x, n, 1.0f / 8.0f);   }
static void gen_tc3(float *x, int n) { gen_stepped(x, n, 1.0f / 256.0f); }
static void gen_tc4(float *x, int n) { (void)n; gen_random(x, N_TC4);    }

int main(void) {
    printf("=== Task 8: Full F(x) hardware accelerator ===\n");
    printf("F(x) = sum of f(x_i), f(x) = 0.5*x + x^3*cos((x-128)/128)\n\n");

    alt_msgdma_dev *dma = alt_msgdma_open(MSGDMA_0_CSR_NAME);
    if (!dma) {
        printf("ERROR: cannot open mSGDMA (%s)\n", MSGDMA_0_CSR_NAME);
        return 1;
    }

    // Sanity check: single element x=128 → f(128)=64+128^3*cos(0)=2097216
    printf("Sanity: x=128 expected F(x)=2097216\n");
    float single_sum = 0.0f;
    clock_t dummy;
    float x_sanity[1] = {128.0f};
    alt_dcache_flush(x_sanity, sizeof(x_sanity));
    IOWR_32DIRECT(DMA_F_X_0_BASE, 0, 1);
    alt_msgdma_standard_descriptor desc;
    alt_msgdma_construct_standard_mm_to_st_descriptor(
        dma, &desc, (alt_u32 *)x_sanity, sizeof(x_sanity),
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_SOP_MASK |
        ALTERA_MSGDMA_DESCRIPTOR_CONTROL_GENERATE_EOP_MASK);
    alt_msgdma_standard_descriptor_async_transfer(dma, &desc);
    volatile uint32_t d = 0;
    while (!(d & 1)) d = IORD_32DIRECT(DMA_F_X_0_BASE, 0);
    uint32_t b = IORD_32DIRECT(DMA_F_X_0_BASE, 4);
    memcpy(&single_sum, &b, 4);
    printf("  HW result: %ld/1024  SW: %ld/1024  %s\n\n",
           (long)(single_sum / 1024.0f),
           (long)(sw_fx(128.0f) / 1024.0f),
           fabsf(single_sum - sw_fx(128.0f)) / sw_fx(128.0f) < 0.001f
               ? "PASS" : "FAIL");
    (void)dummy;

    int all_pass = 1;
    all_pass &= run_test(dma, "TC1 step=5",     x_buf, N_TC1, gen_tc1);
    all_pass &= run_test(dma, "TC2 step=1/8",   x_buf, N_TC2, gen_tc2);
    all_pass &= run_test(dma, "TC3 step=1/256", x_buf, N_TC3, gen_tc3);
    all_pass &= run_test(dma, "TC4 random",     x_buf, N_TC4, gen_tc4);

    printf("\n%s\n", all_pass ? "ALL TESTS PASSED" : "SOME TESTS FAILED");
    return all_pass ? 0 : 1;
}
