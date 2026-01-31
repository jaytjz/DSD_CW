#pragma once
#include <stdint.h>
#include <string.h>
#include <system.h>

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

static inline float cust_fp_mul(float a, float b) {
	uint32_t ur = (uint32_t)ALT_CI_FP_MUL_0(f32_to_u32(a), f32_to_u32(b));
	return u32_to_f32(ur);
}

static inline float cust_fp_add(float a, float b) {
	uint32_t ur = (uint32_t)ALT_CI_FP_ADD_SUB_0(1, f32_to_u32(a), f32_to_u32(b));
	return u32_to_f32(ur);
}

static inline float cust_fp_sub(float a, float b) {
	uint32_t ur = (uint32_t)ALT_CI_FP_ADD_SUB_0(0, f32_to_u32(a), f32_to_u32(b));
	return u32_to_f32(ur);
}