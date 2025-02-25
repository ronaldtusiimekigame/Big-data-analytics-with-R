### SET WORKING DIRECTORY ###
setwd("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)/")

### LOADING LIBRARIES ###
library(tidyverse)
library(tidyr)
library(tidyselect)
library(ggplot2)
library(readxl)
library(readr)

### LOADING THE DATASET ###
df <- read_excel("Bike_Sales.xlsx", sheet = 1)
df

# Viewing the dataset
View(df)

# Checking data types
sapply(df, class)

#### VISUALIZATIONS ####

## 1. Continuous Variables ##

# Scatter plot: Revenue vs Cost by Customer Gender
df %>%
  ggplot(aes(x = Revenue, y = Cost)) + 
  geom_point(size = 2, alpha = 0.5, color = "green") +
  geom_smooth(method = lm, color = "red") +
  facet_wrap(~Customer_Gender) +
  labs(
    x = "Cost",
    y = "Revenue",
    title = "Relationship between Revenue and Cost by Gender"
  )

# Line graph: Ordered Quantity vs Revenue by Customer Gender
df %>%
  ggplot(aes(x = Order_Quantity, y = Revenue)) + 
  geom_line() + 
  theme_bw() +
  facet_wrap(~Customer_Gender) +
  labs(
    x = "Ordered Quantity",
    y = "Revenue",
    title = "Relationship between Ordered Quantity and Revenue by Gender"
  )

# Scatter plot: Unit Price vs Unit Cost
df %>%
  ggplot(aes(x = Unit_Price, y = Unit_Cost)) + 
  geom_point(color = "blue", shape = "*") +
  geom_smooth(method = lm, color = "red") +
  theme_bw() +
  labs(
    x = "Unit Price",
    y = "Unit Cost",
    title = "Unit Price by Unit Cost"
  )

# Scatter plot: Profit vs Revenue by Customer Gender
df %>%
  ggplot(aes(x = Revenue, y = Profit)) + 
  geom_point() + 
  geom_smooth(method = lm, color = "red") +
  theme_bw() +
  facet_wrap(~Customer_Gender) +
  labs(
    x = "Revenue",
    y = "Profit",
    title = "Profit by Revenue Based on Gender"
  )

## 2. Continuous vs Categorical Variables ##

# Boxplot: Revenue by Age Group
df %>%
  ggplot(aes(x = Age_Group, y = Revenue)) + 
  geom_boxplot() +
  coord_flip() +
  labs(
    x = "Age Group",
    y = "Revenue",
    title = "Revenue by Age Group Based on Customer Gender"
  )

# Boxplot: Revenue by Age Group with Theme
df %>%
  ggplot(aes(x = Age_Group, y = Revenue)) + 
  geom_boxplot() +
  theme_bw() +
  labs(
    x = "Age Group",
    y = "Revenue",
    title = "Revenue by Age Group Based on Customer Gender"
  )

# Boxplot: Revenue by Customer Gender
df %>%
  ggplot(aes(x = Customer_Gender, y = Revenue)) + 
  geom_boxplot() +
  theme_bw() +
  labs(
    x = "Customer Gender",
    y = "Revenue",
    title = "Revenue by Customer Gender"
  )

# Boxplot: Revenue by Month
df %>%
  ggplot(aes(x = Month, y = Revenue)) + 
  geom_boxplot() +
  theme_bw() +
  coord_flip() +
  labs(
    x = "Month",
    y = "Revenue",
    title = "Revenue by Month"
  )

## 3. Categorical vs Categorical Variables ##

# Count plot: Country by Age Group
df %>%
  ggplot(aes(x = Age_Group, y = Country)) + 
  geom_count() + 
  theme_bw() +
  labs(
    x = "Age Group",
    y = "Country",
    title = "Count of Country by Age Group"
  )

# Count plot: Month by Age Group
df %>%
  ggplot(aes(x = Age_Group, y = Month)) + 
  geom_count() + 
  theme_bw() +
  labs(
    x = "Age Group",
    y = "Month",
    title = "Count of Month by Age Group"
  )

## Single Categorical Variable ##

# Bar chart: Distribution of Months
df %>%
  ggplot(aes(x = Month, fill = Month)) + 
  geom_bar() +
  theme_bw() +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    x = "Count",
    y = "Month",
    title = "Bar Chart of Month"
  )
