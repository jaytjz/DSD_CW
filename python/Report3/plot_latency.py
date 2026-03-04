import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as patches
from matplotlib.ticker import ScalarFormatter

# -----------------------------
# 1. Load and Clean Data
# -----------------------------
df = pd.read_csv('data.csv', encoding='utf-8-sig', engine='python', on_bad_lines='skip')
df.columns = df.columns.str.strip()
df['Task'] = df['Task'].str.strip()

# Convert FPGA resource column to numeric %
df['Resources'] = df['FPGA Resources'].str.strip().str.rstrip('%').astype(float)
df = df.sort_values('Resources')

# -----------------------------
# 2. Handle Zero Values for Log Scale
# -----------------------------
test_cases = ['Latency TC1', 'Latency TC2', 'Latency TC3']
# Define a 'floor' for zero values (e.g., 0.1 ms)
# This allows them to appear at the bottom of the log graph
LOG_FLOOR = 0.1 

# Create a copy for plotting to avoid changing original data
plot_df = df.copy()
for tc in test_cases:
    plot_df[tc] = pd.to_numeric(plot_df[tc], errors='coerce').fillna(0)
    # Replace 0 or negative with the floor for log compatibility
    plot_df[tc] = np.where(plot_df[tc] <= 0, LOG_FLOOR, plot_df[tc])

# -----------------------------
# 3. Plot Setup
# -----------------------------
tc_labels = ['n = 52', 'n = 2,041', 'n = 65,281']
markers = ['o', 's', '^']
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']

fig, ax = plt.subplots(figsize=(12, 8))

# -----------------------------
# 4. Plot Latency Curves
# -----------------------------
for tc, label, marker, color in zip(test_cases, tc_labels, markers, colors):
    ax.plot(
        plot_df['Resources'],
        plot_df[tc],
        marker=marker,
        color=color,
        linewidth=2,
        markersize=8,
        label=label,
        alpha=0.9,
        zorder=3  # Ensure lines stay above grid/boxes
    )

# -----------------------------
# 5. Set Log Scale and Headroom
# -----------------------------
ax.set_yscale('log')

# Calculate headroom for Task labels (5x the max data point)
y_max_data = plot_df[test_cases].max().max()
y_limit_top = y_max_data * 8  # Increased multiplier for more label space
y_min = 0.05

# -----------------------------
# 6. Add Dashed Task Boxes and High Labels
# -----------------------------
box_width = 0.25

for _, row in df.iterrows():
    res = row['Resources']
    
    # 1. Draw Rectangle (stretch it higher than the data)
    rect = patches.Rectangle(
        (res - box_width / 2, y_min), 
        box_width,
        y_limit_top, 
        linewidth=1,
        edgecolor='black',
        facecolor='none',
        linestyle='--',
        alpha=0.3,
        zorder=1
    )
    ax.add_patch(rect)

    # 2. Task Labels pushed to the headroom area
    ax.text(
        res, 
        y_limit_top * 0.6, # Positioned high above data curves
        row['Task'],
        ha='center', 
        va='top', 
        fontsize=10, 
        fontweight='bold',
        color='black',
        # White background prevents grid line overlap
        bbox=dict(facecolor='white', alpha=0.9, edgecolor='none', pad=1),
        zorder=4
    )

# -----------------------------
# 7. Aesthetics and Layout
# -----------------------------
ax.set_xlabel('FPGA Resource Utilization (%)', fontsize=12)
ax.set_ylabel('Latency (ms) [Log Scale]', fontsize=12)

# Large pad to make room for the legend below the title
ax.set_title('Latency vs FPGA Resource Utilization', fontsize=14, pad=70) 

ax.set_xticks(df['Resources'])
ax.set_ylim(y_min, y_limit_top)
ax.grid(True, which="both", ls="-", alpha=0.2)
ax.yaxis.set_major_formatter(ScalarFormatter())

# Legend placed between title and chart
ax.legend(
    loc='upper center', 
    bbox_to_anchor=(0.5, 1.14), 
    ncol=3, 
    frameon=True,
    fontsize=10,
    edgecolor='gray'
)

# Use rect to prevent the title from being cut off at the top
plt.tight_layout(rect=[0, 0, 1, 0.93]) 

plt.savefig('latency_log_final.png', dpi=200)
print("Plot successfully saved as latency_log_final.png")
plt.show()