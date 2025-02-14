import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression  # Example model
from sklearn.feature_selection import RFE
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler  # For feature scaling (important!)

# 1. Load your data (replace with your actual data loading)
data = pd.read_csv("movies.csv")  # Make sure your data is in a CSV file

# 2. Separate features (X) and target (y)
#X = data.drop("Box Office Revenue", axis=1)# Replace "Box Office Revenue" with your target column name
X = data["Budget"]
y = data["Box Office Revenue"]

# 3. Feature Scaling (Highly Recommended for RFE with many models)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X) # Fit and transform your features

# 4. Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)  # 80% train, 20% test

# 5. Choose a base model (Logistic Regression in this example)
model = LogisticRegression(solver='liblinear')  # solver is important for LogisticRegression with RFE

# 6. Initialize RFE
n_features_to_select = 5  # Choose the number of features you want to keep
rfe = RFE(model, n_features_to_select=n_features_to_select)

# 7. Fit RFE to the training data
rfe.fit(X_train, y_train)

# 8. Get the selected features
selected_features = X.columns[rfe.support_]
print("Selected Features:", selected_features)

# 9. Train the model on the selected features
X_train_selected = rfe.transform(X_train)
X_test_selected = rfe.transform(X_test)

model.fit(X_train_selected, y_train) # Retrain the model on the selected features

# 10. Make predictions on the test set
y_pred = model.predict(X_test_selected)

# 11. Evaluate the model
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)
