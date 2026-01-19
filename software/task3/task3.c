#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>

// Test case 1
//#define step 5
//#define N 52

// Test case 2
//#define step 1/8.0
//#define N 2041

//Test case 3
//#define step 1/256.0
//#define N 65281

// Test Case 4
//#define N 2323
//#define RANDSEED 334
//void generateRandomVector(float x[N])
//{
//    int i;
//    srand(RANDSEED);
//    for (i=0; i<N; i++)
//    {
//        x[i] = ((float) rand()/ (float) RAND_MAX) * MAXVAL;
//    }
//}



// Generates the vector x and stores it in the memory
void generateVector(float x[], int N, float step)
{
	int i;
	x[0] = 0;
	for (i=1; i<N; i++)
		x[i] = x[i-1] + step;
}

float sumVector(float x[], int M)
{
	// YOUR CODE GOES HERE
	float sum = 0.0f;
	for (int i = 0; i < M; i++){
		float xi = x[i];
		sum += 0.5f * xi + (xi * xi * xi) * cosf((xi - 128.0f) / 128.0f);
	}
	return sum;
}

void runTestCase(int testNum, int N, float step)
{
	printf("\n========== Test Case %d ==========\n", testNum);
	printf("N = %d, step = %f\n", N, step);

	float x[N];
	float y;

	printf("Generating vector...\n");
		generateVector(x, N, step);

		printf("Computing sum (10 iterations)...\n");

		clock_t exec_times[10];
		clock_t total_time = 0;

		// Run sumVector 10 times
		for (int run = 0; run < 10; run++)
		{
			clock_t exec_t1, exec_t2;
			exec_t1 = times(NULL);

			y = sumVector(x, N);

			exec_t2 = times(NULL);

			exec_times[run] = exec_t2 - exec_t1;
			total_time += exec_times[run];

			printf("  Run %d: %lu ticks\n", run + 1, exec_times[run]);
		}

		float avg_time = (float)total_time / 10.0f;

		printf("\nResult: %f\n", y);
		printf("Total time (10 runs): %lu ticks\n", total_time);
		printf("Average time: %.2f ticks\n", avg_time);
		printf("===================================\n");
}

int main()
{
	printf("Task 4!\n");

	// Test Case 1: step = 5, N = 52
	runTestCase(1, 52, 5.0f);

	// Test Case 2: step = 1/8.0, N = 2041
	runTestCase(2, 2041, 1.0f/8.0f);

	// Test Case 3: step = 1/256.0, N = 65281
	runTestCase(3, 65281, 1.0f/256.0f);

	printf("\nAll test cases completed!\n");

	return 0;
}
