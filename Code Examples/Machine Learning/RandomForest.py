import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.preprocessing import OneHotEncoder

df = pd.read_csv("movies.csv")
x_keep = ["Genre (1)", "Budget"]
x_drop = [col for col in df.columns if col not in x_keep]
X = df.drop(columns=x_drop)
ohe = OneHotEncoder(handle_unknown='ignore', sparse_output=False).set_output(transform='pandas')
ohetransform = ohe.fit_transform(X["Genre (1)"])
X = pd.concat([X, ohetransform], axis=1).drop(columns='Genre (1)')
y = df["Box Office Revenue"]

print(X.head())

print(X.shape)
print(y.shape)

#80% for training 20% for testing
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=17, test_size=0.2)
rf = RandomForestClassifier()
rf.fit(X_train, y_train)

y_pred = rf.predict(X_test)
print(rf.score(X_test, y_test))
print(classification_report(y_test, y_pred))

