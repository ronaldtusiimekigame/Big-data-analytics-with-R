# Hashtag is seen as a comment
## My script 
3*2
#######Installing Packages For Usage#####
#Package for importing excel data file
install.packages("readxl")

#Once package is installed, you need to call up the library to use the codes in it
library(readxl)

#Code for importing
Data1 <- read_excel("Desktop/Work/Documents/Personal Learning/UCU Classes/Easter_Jan_April_2023/Undergraduate/BSC Data Science 2023/Datasets for Practicum/Bike_Sales.xlsx")
Data1
#To view dataset
View(Data1)

#START BY SETTING UP YOUR WORKING ENVIRONMENT #
setwd("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Trinity_May_Aug_2024/Undegraduate/BSC Data Science_Trinity_2024/Practicals")

#To check the working directory
getwd()

#To generate a new dadtaframe
Name = c("Cathy", "Humble", "Daniel", "Anitah")
Weight = c(40, 52, 78, 101)

#Combine above variables of  name and weight to make a dataframe
# called "class_weight"
class_weight = data.frame(Name, Weight)

## Calculating the central tendency dataframe ##
summary(class_weight)

#The result of a mean = 67.75, median = 65.0 shows the weight is not normally distributed
mean(class_weight)
#The above code gives an error because the variable Name is qualitative
mean(class_weight$Weight)

#Visually plotting the central tendency
boxplot(class_weight$Weight, main="Class Weight", boxwex=0.1)

#Central tendency of Customer_Age in the Bike_Sales dataset
boxplot(Data1$Customer_Age, main="Ages of Customers Buying Bicycle", boxwex=0.1)

#Looking for cental tendency stats
summary(Data1$Customer_Age)

#Display the variable visually using a histogram
hist(class_weight$Weight, main = "Class weight using a histogram")
