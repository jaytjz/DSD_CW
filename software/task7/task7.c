#include <system.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

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

static inline float cust_cordic(float a) {
	uint32_t ur = (uint32_t)ALT_CI_CORDICINSTR_0(f32_to_u32(a));
	return u32_to_f32(ur);
}

static inline float deg_to_rad(float deg) {
    return deg * 3.14159265358979323846f / 180.0f;
}

int main()
{
  printf("Hello from Nios II!\n");

  float angles[] = {-60, -50, -45, -40, -30, -20, -10, 0,
                     10,  20,  30,  40,  45,  50,  60};

  for (int i = 0; i < 15; i++) {
      float rad = deg_to_rad(angles[i]);
      printf("Cordic result: %f\n", cust_cordic(rad));
  }

  return 0;
}
