setwd("C:/Users/RONALD TUSIIME KIGAM/Desktop/Big Data Analytics (R)")


install.packages("tidyverse")
install.packages("tidyr")
install.packages("ggplot")
install.packages("readr")
install.packages("readxl")
install.packages("tidyselect")



library(tidyverse)
library(ggplot2)
library(tidyr)
library(readxl)
library(tidyselect)


#importing a dataset
df <- read_excel("Bike_Sales.xlsx")
df 

#EDA
view(df)

dim(df)

head(df,3)

view(head(df,4))

df %>% 
  head(4) %>% 
  view()
