import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Accurate values for each test case
accurate = {
    'TC1': 170105733.646853,
    'TC2': 6627436274.372950,
    'TC3': 211937410255.291229
}

# Read the data
df = pd.read_csv('data.csv')

# Calculate relative errors for each test case (as percentage)
df['Rel Error TC1'] = abs(df['Accuracy TC1'] - accurate['TC1']) / accurate['TC1'] * 100
df['Rel Error TC2'] = abs(df['Accuracy TC2'] - accurate['TC2']) / accurate['TC2'] * 100
df['Rel Error TC3'] = abs(df['Accuracy TC3'] - accurate['TC3']) / accurate['TC3'] * 100

# Filter out 'cos' function since it matches the accurate values (it's the reference)
df_filtered = df[df['Function'] != 'cos'].copy()

# Create a combined label for Task + Function
df_filtered['Label'] = df_filtered['Task'] + ' - ' + df_filtered['Function']

# Set up the line plot
fig, ax = plt.subplots(figsize=(14, 8))

x = np.arange(len(df_filtered))

# Plot lines for each test case
ax.plot(x, df_filtered['Rel Error TC1'], 'o-', label='Test Case 1', color='#2196F3', linewidth=2, markersize=8)
ax.plot(x, df_filtered['Rel Error TC2'], 's-', label='Test Case 2', color='#4CAF50', linewidth=2, markersize=8)
ax.plot(x, df_filtered['Rel Error TC3'], '^-', label='Test Case 3', color='#FF9800', linewidth=2, markersize=8)

ax.set_xlabel('Task - Function', fontsize=12)
ax.set_ylabel('Relative Error (%)', fontsize=12)
ax.set_title('Relative Error Comparison Across Tasks and Test Cases', fontsize=14)
ax.set_xticks(x)
ax.set_xticklabels(df_filtered['Label'], rotation=45, ha='right')
ax.legend()
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('error_plot.png', dpi=150)
plt.show()

print("\nRelative Error Summary (%):")
print(df_filtered[['Task', 'Function', 'Rel Error TC1', 'Rel Error TC2', 'Rel Error TC3']].to_string(index=False))
