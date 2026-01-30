#include "my_cosf.h"

float my_cosf(float x)
{
	float y[2],z=0.0;
	int32_t n,ix;

	GET_FLOAT_WORD(ix,x);

    /* |x| ~< pi/4 */
	ix &= 0x7fffffff;
	if(ix <= 0x3f490fd8) return my__kernel_cosf(x,z);

    /* cos(Inf or NaN) is NaN */
	else if (!FLT_UWORD_IS_FINITE(ix)) return x-x;

    /* argument reduction needed */
	else {
	    n = my__ieee754_rem_pio2f(x,y);
	    switch(n&3) {
		case 0: return  my__kernel_cosf(y[0],y[1]);
		case 1: return -my__kernel_sinf(y[0],y[1],1);
		case 2: return -my__kernel_cosf(y[0],y[1]);
		default:
		        return  my__kernel_sinf(y[0],y[1],1);
	    }
	}
}