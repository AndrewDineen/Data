import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats  # For z-score calculation (optional)

# Sample Data (with some outliers)
np.random.seed(42)
data = np.concatenate([np.random.normal(10, 2, 90), np.random.normal(50, 10, 10)])
df = pd.DataFrame({'Value': data})

# Visualizing Outliers
plt.figure(figsize=(10, 4))
plt.subplot(1, 2, 1)
plt.hist(df['Value'], bins=20)
plt.title('Histogram of Original Data')

plt.subplot(1, 2, 2)
plt.boxplot(df['Value'], vert=False)
plt.title('Boxplot of Original Data')
plt.show()

#Z-score
z_scores = np.abs(stats.zscore(df['Value']))
outliers_z = df[z_scores > 3]  # Example: Z-score > 3 as outlier

#IQR
Q1 = df['Value'].quantile(0.25)
Q3 = df['Value'].quantile(0.75)
IQR = Q3 - Q1
outliers_iqr = df[(df['Value'] < (Q1 - 1.5 * IQR)) | (df['Value'] > (Q3 + 1.5 * IQR))]