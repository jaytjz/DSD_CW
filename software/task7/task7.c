#include <system.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
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

static inline float sw_f_x(float x) {
    return 0.5f*x + x*x*x * cosf((x - 128.0f) / 128.0f);
}

static void run_test(const char* name, float start, float step, float end) {
    printf("\n=== %s ===\n", name);

    float    mse         = 0.0f;
    float    max_abs_err = 0.0f;
    uint32_t count       = 0;
    float    hw_sum      = 0.0f;
    float    sw_sum      = 0.0f;

    // --- accuracy pass ---
    for (float x = start; x <= end; x += step) {
        float hw      = cust_f_x(x);
        float sw      = sw_f_x(x);
        float err     = hw - sw;
        float abs_err = fabsf(err);

        mse    += err * err;
        hw_sum += hw;
        sw_sum += sw;
        count++;

        if (abs_err > max_abs_err)
            max_abs_err = abs_err;
    }

    mse /= (float)count;
    float rmse = sqrtf(mse);

    printf("Samples        : %lu\n",  count);
    printf("HW sum         : %.6f\n", hw_sum);
    printf("SW sum         : %.6f\n", sw_sum);
    printf("MSE            : %.6e\n", mse);
    printf("RMSE           : %.6e\n", rmse);
    printf("Max abs error  : %.6e\n", max_abs_err);

    // --- timing pass (10 runs over full vector) ---
    printf("Timing (10 runs)...\n");

    alt_u32 exec_times[10];
    alt_u32 total_time = 0;
    float   y          = 0.0f;

    for (int run = 0; run < 10; run++)
    {
        alt_timestamp_start();
        alt_u32 t0 = alt_timestamp();

        for (float x = start; x <= end; x += step)
            y = cust_f_x(x);

        alt_u32 t1      = alt_timestamp();
        exec_times[run] = t1 - t0;
        total_time     += exec_times[run];

        printf("  Run %d: %lu cycles  (%.2f us)\n",
               run + 1, exec_times[run], (float)exec_times[run] * 20.0f / 1000.0f);
    }

    float avg_cycles = (float)total_time / 10.0f;

    printf("Total cycles    : %lu\n",    total_time);
    printf("Avg cycles/run  : %.2f\n",   avg_cycles);
    printf("Avg cycles/call : %.2f\n",   avg_cycles / (float)count);
    printf("Avg time/run    : %.2f us\n", avg_cycles * 20.0f / 1000.0f);
    (void)y;
}

int main() {
    printf("Hello from Nios II!\n");
    printf("f(x) = 0.5*x + x^3 * cos((x-128)/128)\n");

    float test_in  = 128.0f;
    float test_hw  = cust_f_x(test_in);
    float test_sw  = sw_f_x(test_in);
    printf("x=128: hw=%.6f  sw=%.6f\n", test_hw, test_sw);

    test_in = 0.0f;
    test_hw = cust_f_x(test_in);
    test_sw = sw_f_x(test_in);
    printf("x=0:   hw=%.6f  sw=%.6f\n", test_hw, test_sw);

    run_test("Test Case 1: step=5",      0.0f, 5.0f,        255.0f);
    run_test("Test Case 2: step=1/8",    0.0f, 1.0f/8.0f,   255.0f);
    run_test("Test Case 3: step=1/256",  0.0f, 1.0f/256.0f, 255.0f);

    return 0;
}
