// #include <stdio.h>
       
// #include <stdint.h>
// #include <math.h>
typedef int int32_t;
/* A union which permits us to convert between a float and a 32 bit

   int.  */
typedef union
{
  float value;
  int32_t word;
} ieee_float_shape_type;
/* Get a 32 bit int from a float.  */
/* Set a float from a 32 bit int.  */
extern int my__kernel_rem_pio2f (float*,float*,int,int,int,const int32_t*);
extern int32_t my__ieee754_rem_pio2f (float,float*);
extern float my__kernel_sinf (float,float,int);
extern float my__kernel_cosf (float,float);
extern float my_cosf(float);
int main() {
    double TEST = 20;
    double x = cos(TEST);
    float y = cosf(TEST);
    float z = my_cosf(TEST);
    // printf("%.20f, %.20f, %.20f", x, y, z);
    return 0;
}
