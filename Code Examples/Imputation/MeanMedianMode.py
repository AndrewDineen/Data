import pandas as pd
from sklearn.impute import KNNImputer

# Load data from CSV file
data = pd.read_csv("running.csv")

# Select the features to use for imputation (optional)
features_to_impute = ['Sleep Duration (hrs)', 'Sleep Score']
data_to_impute = data[features_to_impute]

# Initialize KNNImputer
imputer = KNNImputer(n_neighbors=2)

# Fit and transform the data
imputed_data = imputer.fit_transform(data_to_impute)

# Replace the original columns with imputed values
data[features_to_impute] = imputed_data

data.to_csv("knn_imputed_data.csv", index=False)