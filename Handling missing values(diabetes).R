#DEALING WITH OUTLIERS
setwd("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)")
library(tidyr)
library(ggplot2)
library(readxl)
library(readr)
library(dplyr)
library(data.table)

df <- fread("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)/Diabetes Missing Data.csv")

View(df)
summary(df)
sum(is.na(df$Diastolic_BP))

#Imputing with mean
df4 = df[,Serum_Insulin:= fifelse(is.na(Serum_Insulin),mean(Serum_Insulin,na.rm = TRUE),Serum_Insulin)]

#Imputing with mean.
df8 = df[,Diastolic_BP := fifelse(is.na(Diastolic_BP),mean(Diastolic_BP,na.rm = TRUE),Diastolic_BP)]

#imputing with median
df1 = df[,Glucose:= fifelse(is.na(Glucose),median(Glucose,na.rm = TRUE),Glucose)]
View(df1)

df4 = df[,]
#FOrward filling
df2 = df[,BMI := nafill(BMI,type = "locf")]
View(df2)

#Backward Filling
df3 = df[,Skin_Fold := nafill(Skin_Fold, type = "nocb")]
View(df3)

#checking for duplicate data
df [duplicated(df)]
df.new <- unique(df) #removing duplicates

#checking for numeric data
numerical <- df %>% 
  select_if(is.numeric)

#finding the interquartile range
Q1 = df[,quantile(Glucose,0.25)]
Q3 = df[,quantile(Glucose,0.75)]

IQR = Q3 - Q1

lowerbound = Q1 - 1.5*IQR
upperbound = Q3 - 1.5*IQR

Outlier = df[Glucose < lowerbound | Glucose > upperbound]

remove_outlier = df[Glucose >= lowerbound & Glucose <= upperbound]






