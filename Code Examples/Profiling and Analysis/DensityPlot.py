import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Load the data from the CSV file
df = pd.read_csv("movies.csv")  # Replace "your_file.csv" with the actual file name

# Choose the column for which you want to create the density plot

column_name = "Budget"  # Replace "your_column" with the actual column name
data = df[column_name]
df[column_name] = pd.to_numeric(df[column_name], errors='coerce') # Convert to numeric, handle errors
data = df[column_name] # re-select the column after conversion
data = data.dropna()
print(f"Minimum value in {column_name}: {data.min()}")
print(f"Maximum value in {column_name}: {data.max()}")
print(f"Data type of {column_name}: {data.dtype}")

# Create the density plot using seaborn
# fill=True fills under the curve, cut = 0 prevents the plot smoothing from throwing the values into the negatives
sns.kdeplot(data, fill=True, color="skyblue", linewidth=2, cut=0)  

# Customize the plot (optional)
formatter = ticker.EngFormatter() # This automatically handles K, M, G, etc.
plt.gca().xaxis.set_major_formatter(formatter)
plt.title(f"Density Plot of {column_name}")
plt.xlabel(column_name)
plt.ylabel("Density")
plt.grid(True, linestyle="--", alpha=0.7)  # Add a grid for better readability
plt.ticklabel_format(style='plain', axis='x')
# Show the plot
plt.show()

# Save the plot (optional)
# plt.savefig("density_plot.png")  # Saves the plot as a PNG image