import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as patches
from matplotlib.ticker import LogLocator, NullFormatter

# -----------------------------
# 1. Reference (Double Precision)
# -----------------------------
accurate = {
    'TC1': 170105733.646853,
    'TC2': 6627436274.372950,
    'TC3': 211937410255.291229,
}

# -----------------------------
# 2. Load and Clean Data
# -----------------------------
df = pd.read_csv('data.csv', encoding='utf-8-sig', engine='python', on_bad_lines='skip')
df.columns = df.columns.str.strip()
df['Task'] = df['Task'].str.strip()

# Convert FPGA resource column to numeric %
df['Resources'] = (
    df['FPGA Resources']
    .astype(str)
    .str.strip()
    .str.rstrip('%')
    .astype(float)
)

# Convert accuracy columns to float
accuracy_cols = ['Accuracy TC1', 'Accuracy TC2', 'Accuracy TC3']
df[accuracy_cols] = df[accuracy_cols].astype(float)

# -----------------------------
# 3. Compute Relative Error (%)
# -----------------------------
df['Rel Error TC1'] = abs(df['Accuracy TC1'] - accurate['TC1']) / accurate['TC1'] * 100
df['Rel Error TC2'] = abs(df['Accuracy TC2'] - accurate['TC2']) / accurate['TC2'] * 100
df['Rel Error TC3'] = abs(df['Accuracy TC3'] - accurate['TC3']) / accurate['TC3'] * 100

# Sort by increasing resource usage for a clean line plot
df = df.sort_values('Resources')

# -----------------------------
# 4. Handle Zeros & Tighten Limits
# -----------------------------
error_cols = ['Rel Error TC1', 'Rel Error TC2', 'Rel Error TC3']
# Set a floor only for absolute zero values
LOG_FLOOR = 1e-10 

plot_df = df.copy()
for col in error_cols:
    plot_df[col] = np.where(plot_df[col] <= 0, LOG_FLOOR, plot_df[col])

# Calculate tight Y-limits based on actual data range
y_max_data = plot_df[error_cols].values.max()
y_min_data = plot_df[error_cols].values.min()

# Ceiling: One power of 10 above the max data point
y_limit_top = 10**np.ceil(np.log10(y_max_data))
# Floor: One power of 10 below the min data point
y_limit_bottom = 10**np.floor(np.log10(y_min_data))

# -----------------------------
# 5. Plot Setup
# -----------------------------
fig, ax = plt.subplots(figsize=(12, 8))
ax.set_yscale('log')

labels = ['n = 52', 'n = 2,041', 'n = 65,281']
markers = ['o', 's', '^']
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']

# -----------------------------
# 6. Plot Error Curves
# -----------------------------
for col, label, marker, color in zip(error_cols, labels, markers, colors):
    ax.plot(
        plot_df['Resources'],
        plot_df[col],
        marker=marker,
        color=color,
        linewidth=2,
        markersize=8,
        label=label,
        zorder=3
    )

# -----------------------------
# 7. Add Dashed Task Boxes and Labels
# -----------------------------
box_width = 0.25

for _, row in df.iterrows():
    res = row['Resources']

    # Rectangle spanning exactly from tight floor to tight ceiling
    rect = patches.Rectangle(
        (res - box_width / 2, y_limit_bottom),
        box_width,
        y_limit_top - y_limit_bottom,
        linewidth=1,
        edgecolor='black',
        facecolor='none',
        linestyle='--',
        alpha=0.25,
        zorder=1
    )
    ax.add_patch(rect)

    # Place Task labels inside the plot but at the top
    ax.text(
        res,
        y_limit_top * 0.75, 
        row['Task'],
        ha='center',
        va='top',
        fontsize=10,
        fontweight='bold',
        bbox=dict(facecolor='white', alpha=0.9, edgecolor='none', pad=1),
        zorder=4
    )

# -----------------------------
# 8. Aesthetics & Final Layout
# -----------------------------
ax.set_xlabel('FPGA Resource Utilization (%)', fontsize=12)
ax.set_ylabel('Relative Error (%) [Log Scale]', fontsize=12)
ax.set_title('Relative Error vs FPGA Resource Utilization', fontsize=14, pad=45)

ax.set_xticks(df['Resources'])
ax.set_ylim(y_limit_bottom, y_limit_top)

# Grid styling - show major decades and subtle minor lines
ax.grid(True, which="major", ls="-", alpha=0.3)
ax.grid(True, which="minor", ls=":", alpha=0.1)

# Compact legend placement
ax.legend(
    loc='upper center',
    bbox_to_anchor=(0.5, 1.08),
    ncol=3,
    frameon=True,
    edgecolor='gray'
)

# Set the figure layout to use the full space efficiently
plt.tight_layout(rect=[0, 0, 1, 0.96])

plt.savefig('relative_error_tight.png', dpi=200)
print("Plot successfully saved as relative_error_tight.png")
plt.show()