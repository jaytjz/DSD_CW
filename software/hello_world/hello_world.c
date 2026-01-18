#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>

// Test case 1
//#define step 5
//#define N 52

// Test case 2
//#define step 1/8.0
//#define N 2041

//Test case 3
#define step 1/256.0
#define N 65281


// Generates the vector x and stores it in the memory
void generateVector(float x[N])
{
	int i;
	x[0] = 0;
	for (i=1; i<N; i++)
		x[i] = x[i-1] + step;
}

float sumVector(float x[], int M)
{
	// YOUR CODE GOES HERE
	float sum = 0.0;
	for (int i = 0; i < M; i++){
		sum += x[i];
	}
	return sum;
}

int main()
{
  printf("Task 2!\n");
  printf("N = %d\n", N);

  // Define input vector
  float x[N];

  // Returned result
  float y;

  generateVector(x);

  // The following is used for timing
  clock_t exec_t1, exec_t2;

  exec_t1 = times(NULL); // get system time before starting the process

  // The code that you want to time goes here
  y = sumVector(x, N);

  // till here
  exec_t2 = times(NULL); // get system time after finishing the process


  y = y/1024.0;

  printf("Result (sum/1024): %d\n", (int)y);
  printf("T1: %lu\n", exec_t1);
  printf("T2: %lu\n", exec_t2);
  printf("Time: %lu\n", exec_t2 - exec_t1);

  return 0;
}
