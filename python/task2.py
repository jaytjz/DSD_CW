import time
from decimal import Decimal, getcontext

# Set high precision for Decimal (similar to long double)
getcontext().prec = 50

# Test cases
test_cases = [
    {"name": "Test case 1", "step": 5.0, "N": 52},
    {"name": "Test case 2", "step": 1/8.0, "N": 2041},
    {"name": "Test case 3", "step": 1/256.0, "N": 65281}
]

def generateVector(N, step):
    """Generates the vector x and stores it in memory"""
    x = [0.0] * N
    for i in range(1, N):
        x[i] = x[i-1] + step
    return x

def sumVector(x, M):
    """Sums the first M elements of vector x"""
    sum_val = 0.0
    for i in range(M):
        sum_val += x[i]
    return sum_val

def main():
    print("=" * 60)
    print("Task 2 - All Test Cases")
    print("=" * 60)
    
    for idx, test in enumerate(test_cases, 1):
        print(f"\n{'='*60}")
        print(f"{test['name']}")
        print(f"{'='*60}")
        
        step = test['step']
        N = test['N']
        
        print(f"Step: {step}")
        print(f"N = {N}")
        
        # Define input vector
        x = generateVector(N, step)
        
        # Timing
        t1 = time.perf_counter()
        
        # The code to time
        y = sumVector(x, N)
        
        t2 = time.perf_counter()
        
        # Results
        y_divided = y / 1024.0
        
        print(f"\nResults:")
        print(f"  Sum (raw): {y}")
        print(f"  Result (sum/1024): {int(y_divided)}")

if __name__ == "__main__":
    main()