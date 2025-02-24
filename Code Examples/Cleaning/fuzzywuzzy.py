#Standardizes names across multiple tables with country name column
import pandas as pd
from fuzzywuzzy import fuzz, process

# Sample Data (replace with your actual data)
data = {
    'table_a_country': ['Congo', 'USA', 'Germany', 'France', 'Japan'],
    'table_b_country': ['Congo, Rep.', 'U.S.A.', 'Deutschland', 'France', 'Nippon']
}
df = pd.DataFrame(data)

# 1. Create a Standardized Country List:
# This could come from a reliable source or a manual curation process.
standard_countries = ['Congo', 'USA', 'Germany', 'France', 'Japan']

# 2. Fuzzy Matching and Standardization:
def standardize_country(country_name):
    # Use fuzzywuzzy's process.extractOne to find the best match
    match, score = process.extractOne(country_name, standard_countries)

    # Set a threshold for matching (adjust as needed)
    if score >= 80:  # Example threshold - adjust as needed
        return match  # Return the standardized country name
    else:
        return country_name  # Return the original if no good match

# Apply the standardization function to both columns
df['table_a_country_standardized'] = df['table_a_country'].apply(standardize_country)
df['table_b_country_standardized'] = df['table_b_country'].apply(standardize_country)

print(df)


# Example of how to use the standardized values to merge/join
# You would typically load your data from database tables into pandas DataFrames first.
# This example just demonstrates the principle

# Sample dataframes (replace with your actual dataframes)
table_a = pd.DataFrame({'country': ['Congo', 'USA', 'Germany'], 'other_a_data': [1,2,3]})
table_b = pd.DataFrame({'country': ['Congo, Rep.', 'U.S.A.', 'Deutschland'], 'other_b_data': [4,5,6]})

# Standardize the country names in the dataframes
table_a['country_standardized'] = table_a['country'].apply(standardize_country)
table_b['country_standardized'] = table_b['country'].apply(standardize_country)

# Now you can merge using the standardized country names
merged_df = pd.merge(table_a, table_b, left_on='country_standardized', right_on='country_standardized', how='inner')
print(merged_df)


# If you need to update your database:
# 1. Connect to your PostgreSQL database using psycopg2 or SQLAlchemy.
# 2. Use a loop or vectorized operations to update the country names in your tables
#    based on the standardized values in your DataFrame.

# Example of how to update a PostgreSQL table (using psycopg2):
import psycopg2

conn = psycopg2.connect("your_connection_string")  # Replace with your connection details
cur = conn.cursor()

for index, row in df.iterrows():
    try:
        cur.execute("UPDATE your_table SET country = %s WHERE country = %s", (row['table_b_country_standardized'], row['table_b_country']))
        conn.commit()
    except psycopg2.Error as e:
        conn.rollback()  # Rollback on error
        print(f"Error updating row: {e}")

cur.close()
conn.close()