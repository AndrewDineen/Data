install.packages("readr", "tidyr", "dplyr")
library("readr", "tidyr", "dplyr")

setwd("C:/Users/addin.DESKTOP-VNI86BL/Desktop/Data/Global Birth Rates Project/Inflation")
inflation_df <- read_csv("inflation.csv")
print(problems(inflation_df), n=267)
glimpse(inflation_df)

inflation_df_long <- inflation_df %>% pivot_longer(cols=5:69,
                                                   names_to = "year",
                                                   values_to = "value")
write.csv(inflation_df_long, )
