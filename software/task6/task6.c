#include <system.h>
#include <stdio.h>
#include <sys/times.h>

int main()
{
  printf("Hello from Nios II!\n");
  printf("=== Custom Instruction Tests ===\n\n");

  // Test 1: Integer Multiply
  printf("--- Integer Multiply ---\n");
  int int_a = 5;
  int int_b = 7;
  int int_result = ALT_CI_MUL_0(int_a, int_b);
  printf("%d * %d = %d (expected: 35)\n\n", int_a, int_b, int_result);

  // Test 2: FP Multiply
  printf("--- FP Multiply ---\n");
  float a = 2.5f;
  float b = 3.2f;
  float result;
  *(unsigned int*)&result = ALT_CI_FP_MUL_0(
      *(unsigned int*)&a,
      *(unsigned int*)&b
  );
  printf("%.1f * %.1f = %.1f (expected: 8.0)\n\n", a, b, result);

  // Test 3: FP Add
  printf("--- FP Add ---\n");
  a = 1.5f;
  b = 2.5f;
  *(unsigned int*)&result = ALT_CI_FP_ADD_0(
      *(unsigned int*)&a,
      *(unsigned int*)&b
  );
  printf("%.1f + %.1f = %.1f (expected: 4.0)\n\n", a, b, result);

  // Test 4: FP Subtract
  printf("--- FP Subtract ---\n");
  a = 5.0f;
  b = 3.0f;
  *(unsigned int*)&result = ALT_CI_FP_SUB_0(
      *(unsigned int*)&a,
      *(unsigned int*)&b
  );
  printf("%.1f - %.1f = %.1f (expected: 2.0)\n\n", a, b, result);

  printf("=== All Tests Complete ===\n");

  return 0;
}
