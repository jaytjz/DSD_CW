#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <system.h>
#include <io.h>
#include <sys/alt_cache.h>

// dma_cordic register map (byte offsets)
// offset  0 = src_base  (R/W) – source array of IEEE 754 float x values
// offset  4 = dst_base  (R/W) – destination array for f(x) results
// offset  8 = go/done   (write 1 = GO, read bit[0] = done)
// offset 12 = length    (R/W) – number of float values to process
//
// Computes f(x) = 0.5*x + x^3 * cos((x-128)/128) for each element.

// src and dst MUST be in SDRAM (global/static), not on the stack.
// Returns 0 on success, -1 on timeout.
int dma_fx_run(float *src, float *dst, uint32_t length) {
    // Write-back src so DMA reads the latest values from SDRAM
    alt_dcache_flush((void*)src, length * sizeof(float));

    IOWR_32DIRECT(DMA_F_X_0_BASE, 0,  (uint32_t)src);
    IOWR_32DIRECT(DMA_F_X_0_BASE, 4,  (uint32_t)dst);
    IOWR_32DIRECT(DMA_F_X_0_BASE, 12, length);
    IOWR_32DIRECT(DMA_F_X_0_BASE, 8,  1);  // GO (also clears done)

    for (int i = 0; i < 10000000; i++) {
        if (IORD_32DIRECT(DMA_F_X_0_BASE, 8) & 1) {
            // Invalidate dst so CPU reads DMA-written values, not stale cache
            alt_dcache_flush_no_writeback((void*)dst, length * sizeof(float));
            return 0;
        }
    }
    printf("dma_fx_run: TIMEOUT\n");
    return -1;
}

static float ref_fx(float x) {
    return 0.5f * x + x*x*x * cosf((x - 128.0f) / 128.0f);
}

// Arrays must be global/static so the linker places them in SDRAM,
// which the DMA Avalon master port can access.
#define N 8
static float x_in[N];
static float result[N];

int main() {
    printf("=== DMA f(x) Test ===\n");
    printf("src  = 0x%08lx\n", (unsigned long)x_in);
    printf("dst  = 0x%08lx\n", (unsigned long)result);

    // Sample x values across [0, 255]
    for (int i = 0; i < N; i++)
        x_in[i] = (float)i * 255.0f / (N - 1);

    if (dma_fx_run(x_in, result, N) != 0)
        return 1;

    int pass = 0, fail = 0;
    for (int i = 0; i < N; i++) {
        float expected = ref_fx(x_in[i]);
        float err      = result[i] - expected;
        if (err < 0) err = -err;
        float rel_err  = (expected != 0.0f) ? err / fabsf(expected) : err;
        int ok = (rel_err < 0.001f);
        printf("  f(%.2f) = %.4f  expected %.4f  rel_err %.2e  %s\n",
               x_in[i], result[i], expected, rel_err, ok ? "PASS" : "FAIL");
        if (ok) pass++; else fail++;
    }

    printf("\n%d passed, %d failed\n", pass, fail);
    return (fail > 0) ? 1 : 0;
}
