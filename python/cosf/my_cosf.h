#pragma once

#include <stdint.h>
#include <math.h>

#define FLT_UWORD_IS_FINITE(x) ((x)<0x7f800000L)

/* A union which permits us to convert between a float and a 32 bit
   int.  */
typedef union
{
  float value;
  int32_t word;
} ieee_float_shape_type;

/* Get a 32 bit int from a float.  */
#define GET_FLOAT_WORD(i,d)					\
do {								\
  ieee_float_shape_type gf_u;					\
  gf_u.value = (d);						\
  (i) = gf_u.word;						\
} while (0)

/* Set a float from a 32 bit int.  */
#define SET_FLOAT_WORD(d,i)					\
do {								\
  ieee_float_shape_type sf_u;					\
  sf_u.word = (i);						\
  (d) = sf_u.value;						\
} while (0)

extern int   my__kernel_rem_pio2f (float*,float*,int,int,int,const int32_t*);
extern int32_t my__ieee754_rem_pio2f (float,float*);
extern float my__kernel_sinf (float,float,int);
extern float my__kernel_cosf (float,float);
extern float my_cosf(float);