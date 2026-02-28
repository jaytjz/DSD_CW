#include <system.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "sys/alt_timestamp.h"

static inline uint32_t f32_to_u32(float x) {
    uint32_t u;
    memcpy(&u, &x, sizeof(u));
    return u;
}

static inline float u32_to_f32(uint32_t u) {
    float x;
    memcpy(&x, &u, sizeof(x));
    return x;
}

static inline float cust_f_x(float a) {
    uint32_t ur = (uint32_t)ALT_CI_F_X_0(f32_to_u32(a));
    return u32_to_f32(ur);
}

static inline double sw_f_x(double x) {
    return 0.5*x + x*x*x * cos((x - 128.0) / 128.0);
}

static void run_test(const char* name, float start, float step, float end) {
    printf("\n=== %s ===\n", name);

    double   mse          = 0.0;
    double   max_abs_err  = 0.0;
    uint32_t count        = 0;
    uint64_t total_cycles = 0;

    for (float x = start; x <= end; x += step) {

        alt_timestamp_start();
        alt_u32 t0  = alt_timestamp();
        float hw    = cust_f_x(x);
        alt_u32 t1  = alt_timestamp();

        double sw   = sw_f_x((double)x);
        double err  = (double)hw - sw;
        double abs_err = fabs(err);

        mse          += err * err;
        total_cycles += (t1 - t0);
        count++;

        if (abs_err > max_abs_err)
            max_abs_err = abs_err;
    }

    mse /= count;

    printf("Samples        : %lu\n",        count);
    printf("MSE            : %.6e\n",        mse);
    printf("Max abs error  : %.6e\n",        max_abs_err);
    printf("Avg cycles/call: %.2f\n",        (double)total_cycles / count);
    printf("Total cycles   : %llu\n",        total_cycles);
    printf("Total time (ns): %.2f\n",        (double)total_cycles * 20.0);
}

int main() {
    printf("Hello from Nios II!\n");
    printf("f(x) = 0.5*x + x^3 * cos((x-128)/128)\n");

    // Test case 1: X = 0:5:255
    run_test("Test Case 1: step=5",      0.0f, 5.0f,        255.0f);

    // Test case 2: X = 0:1/8:255
    run_test("Test Case 2: step=1/8",    0.0f, 1.0f/8.0f,   255.0f);

    // Test case 3: X = 0:1/256:255
    run_test("Test Case 3: step=1/256",  0.0f, 1.0f/256.0f, 255.0f);

    return 0;
}
