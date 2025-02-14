import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats  # For z-score calculation

# Sample Data (with some outliers)
np.random.seed(42)
data = np.concatenate([np.random.normal(10, 2, 90), np.random.normal(50, 10, 10)])
df = pd.DataFrame({'Value': data})

df['Sqrt_Value'] = df['Value']
df['Log_Value'] = df['Value']

# Applying the Transform Only to Outliers
# Doesn't make a lot of sense to use z-score in this case, just for practice
df['z-score'] = np.abs(stats.zscore(df['Value']))

outliers = df[df['z-score'] > 3].index

df.loc[outliers, 'Sqrt_Value'] = np.sqrt(df.loc[outliers, 'Value'])
df.loc[outliers,'Log_Value'] = np.log1p(df.loc[outliers,'Value'])

print(df)

# Visualizing Transformed Data
plt.figure(figsize=(15, 4))

plt.subplot(1, 3, 1)
plt.hist(df['Value'], bins=20)
plt.title('Histogram of Original Data')

plt.subplot(1, 3, 2)
plt.hist(df['Sqrt_Value'], bins=20)
plt.title('Histogram of Square Root Transformed Data')

plt.subplot(1, 3, 3)
plt.hist(df['Log_Value'], bins=20)
plt.title('Histogram of Log Transformed Data')

plt.show()

plt.figure(figsize=(15, 4))

plt.subplot(1, 3, 1)
plt.boxplot(df['Value'], vert=False)
plt.title('Boxplot of Square Root Transformed Data')

plt.subplot(1, 3, 2)
plt.boxplot(df['Sqrt_Value'], vert=False)
plt.title('Boxplot of Square Root Transformed Data')

plt.subplot(1, 3, 3)
plt.boxplot(df['Log_Value'], vert=False)
plt.title('Boxplot of Log Transformed Data')

plt.show()
