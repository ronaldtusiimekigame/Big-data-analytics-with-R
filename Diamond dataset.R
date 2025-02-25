#preprocessing

library(readr)
library(tidyverse)
library(readxl)
library(tidyr)
library(ggplot2)



#loading data
data <- read.csv("C:/Users/RONALD TUSIIME KIGAM/Desktop/YEAR 2_2/Big Data Analytics (R)/diamonds.csv")
head(data)
view(data)


#structure of the data
str(data)

#summarise the stats.
summary(data)

#handling missing values-----
##Approach1
missing_values <- sapply(data, function(x) sum(is.na(x)))
missing_values

##Approach2
missing_values_two <- data %>% summarise(numeric_missing = sum(is.na(.)), categorical_missing = sum(is.na(as.character(.))))
missing_values_two

##Approach 3
missing_values_three <- data %>% summarise_all(funs(sum(is.na(.))))
missing_values_three

##Removing missing values

#approach 1
##droping
new_data = na.omit(data)

class(data$color)
class(data$depth)

hist(data$depth, col = 'blue', main = "Histogram for depth")

##inputting for missing values.
inpute_mean <- function(x) replace(x, is.na(x),mean(x,na.rm = TRUE))#normalized numerical data
inpute_median <- function(x) replace(x, is.na(x),mean(x,na.rm = TRUE))#skewed numerical data
inpute_mode <- function(x){
  model_value < as.numeric(names(table(sort(x), decreasing = TRUE)[1]))##categorical data
  replace(x,is.na(x), model_value)
}

##calling the function to remove missing values 
inpute_mean(data$depth)
inpute_mode(data$color)
