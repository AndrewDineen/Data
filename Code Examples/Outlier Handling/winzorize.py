import numpy as np
import pandas as pd
from scipy.stats.mstats import winsorize

# df = pd.read_csv("running.csv")

# distance = df["Distance (mi)"]
data = np.array([2, 5, 8, 12, 15, 18, 22, 25, 28, 30, 100, 150])  # Example data with outliers
data = data.astype(float)
# Winsorize at the 5th and 95th percentiles
winsorized_data = winsorize(data, limits=[0.05, 0.05])  # limits are [lower_percentile, upper_percentile]
print("\nDescriptive Statistics (Before Winsorization):")
print("Original data:", pd.DataFrame(data).describe())

print("\nDescriptive Statistics (After Winsorization):")
print("Winsorized data:", pd.DataFrame(winsorized_data.data).describe())

print(winsorized_data.data)