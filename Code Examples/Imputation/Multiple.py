import pandas as pd
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer

# Load the data from the CSV file
data = pd.read_csv("running.csv")

# Select the features to use for imputation (optional)
features_to_impute = ['Sleep Duration (hrs)', 'Sleep Score']
data_to_impute = data[features_to_impute]

# Create an IterativeImputer instance (MICE)
#Random state is like a seed that guarantees reproducibility
imputer = IterativeImputer(max_iter=10, random_state=0)  # Adjust max_iter as needed

# Fit and transform the data to impute missing values
imputed_data = imputer.fit_transform(data_to_impute)

# Convert the imputed data back to a DataFrame
imputed_df = pd.DataFrame(imputed_data, columns=data_to_impute.columns)

# Print or save the imputed DataFrame (optional)
imputed_df.to_csv("multiple_imputed_data.csv", index=False)
# imputed_df.to_csv("imputed_running.csv", index=False)  # To save to a new CSV file