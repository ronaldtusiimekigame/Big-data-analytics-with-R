# Load necessary libraries
library(tidyverse)
library(readxl)
library(ggplot2)
library(dplyr)

# Set working directory
setwd("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)")

# Read dataset
BikesDataset <- read_excel("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)/Bike_Sales.xlsx")

####### Visualizations #######

## 1. Continuous Variables
# Scatter plot: Relationship between Revenue and Cost by Gender
BikesDataset %>%
  ggplot(aes(x=Revenue, y=Cost)) + 
  geom_point(size=3, alpha=0.6, color="purple") +
  geom_smooth(method="loess", color="darkred", se=FALSE) + 
  facet_grid(~Customer_Gender) +
  theme_minimal() +
  labs(x="Total Revenue",
       y="Total Cost",
       title="Revenue vs Cost: Comparison by Gender")

# Unit cost vs Unit price with different colors
BikesDataset %>%
  ggplot(aes(x=Unit_Price, y=Unit_Cost)) + 
  geom_point(color="orange", alpha=0.7, shape=17) +
  geom_smooth(method="lm", color="black", se=FALSE) +
  theme_light() +
  labs(x="Unit Price ($)",
       y="Unit Cost ($)",
       title="Unit Price vs Unit Cost")

## 2. Continuous and Categorical Variable

# Boxplot: Revenue by Age Group and Customer Gender
BikesDataset %>%
  ggplot(aes(x=Age_Group, y=Revenue, fill=Customer_Gender)) + 
  geom_boxplot(alpha=0.8) +
  scale_fill_manual(values=c("Male"="skyblue", "Female"="pink")) +
  theme_minimal() +
  labs(x="Age Group",
       y="Revenue ($)",
       title="Revenue Distribution Across Age Groups & Gender")

# Boxplot: Revenue by Gender with a different color scheme
BikesDataset %>%
  ggplot(aes(x=Customer_Gender, y=Revenue, fill=Customer_Gender)) + 
  geom_boxplot(alpha=0.7) +
  scale_fill_brewer(palette="Pastel1") +
  theme_minimal() +
  labs(x="Gender",
       y="Revenue ($)",
       title="Revenue Variation Across Genders")

## 3. Categorical vs Categorical

# Count plot: Age Group vs Month
BikesDataset %>%
  ggplot(aes(x=Age_Group, y=Month)) +
  geom_count(color="darkgreen", alpha=0.7) + 
  theme_light() +
  labs(x="Age Group",
       y="Month",
       title="Monthly Sales Distribution Across Age Groups")

# Single Categorical Variable: Bar Chart of Months
BikesDataset %>%
  ggplot(aes(x=Month, fill=Month)) + 
  geom_bar(alpha=0.8) +
  theme_minimal() +
  scale_fill_brewer(palette="Set2") +
  labs(x="Month",
       y="Count",
       title="Monthly Sales Distribution")
