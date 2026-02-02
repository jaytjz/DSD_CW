import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read the data (handle Windows line endings and varying field counts)
df = pd.read_csv('data.csv', encoding='utf-8-sig', engine='python', on_bad_lines='skip')

# Get unique functions
functions = df['Function'].unique()

# Extract numeric resource utilization values
df['Resources'] = df['FPGA Resources'].str.rstrip('%').astype(int)

test_cases = ['Latency TC1', 'Latency TC2', 'Latency TC3']
colors = {'cos': '#1f77b4', 'cosf': '#ff7f0e', 'Taylor8': '#2ca02c', 'my_cosf': '#d62728'}
markers = {'cos': 'o', 'cosf': 's', 'Taylor8': '^', 'my_cosf': 'd'}

# Create separate figure for each test case
for tc in test_cases:
    fig, ax = plt.subplots(figsize=(8, 5))

    for func in functions:
        func_data = df[df['Function'] == func]
        resources = func_data['Resources'].values
        latencies = func_data[tc].values
        ax.plot(resources, latencies, color=colors[func], marker=markers[func],
                markersize=8, linewidth=2, label=func)

    tc_name = tc.split()[-1]
    ax.set_xlabel('FPGA Resource Utilization (%)', fontsize=12)
    ax.set_ylabel('Latency (ms)', fontsize=12)
    ax.set_title(f'Latency vs Resource Utilization - {tc_name}', fontsize=14)
    ax.legend(loc='best', fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    filename = f'latency_plot_{tc_name}.png'
    plt.savefig(filename, dpi=150)
    print(f"Plot saved as {filename}")

plt.show()
