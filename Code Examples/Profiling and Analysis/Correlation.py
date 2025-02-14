import pandas as pd
import scipy.stats as stats

filepath = "movies.csv"  
variable1 = "Budget ($)"  
variable2 = "Box Office Revenue ($)"  

try:
    df = pd.read_csv(filepath)

    if variable1 not in df.columns or variable2 not in df.columns:
        print(f"Error: Columns '{variable1}' or '{variable2}' not found in the CSV.")
    else:
        var1 = df[variable1]
        var2 = df[variable2]
        

        correlation_coefficient, p_value = stats.pearsonr(var1, var2)


        print(f"Pearson Correlation Coefficient: {correlation_coefficient}")
        print(f"P-value: {p_value}")
        
        alpha = 0.05
        if p_value < alpha:
            print("The correlation is statistically significant.")
        else:
            print("The correlation is not statistically significant.")

except FileNotFoundError:
    print(f"Error: File not found at '{filepath}'.")
except Exception as e:
    print(f"An error occurred: {e}")