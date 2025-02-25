###ANALYSING BIG DATA: DATA PREPROCESSING USING DATA.TABLE PACKAGE
#*
##1. Further resources
#Process time of a job
proc.time()
system.time()
#To check what a code does
?proc.time
?system.time
#Response: proc.time determines how much real and CPU time (in seconds) the currently running R process has already taken.

#For instance to check the process time of importing a dataset and getting it's descriptive stats
start_time = proc.time()
setwd("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Easter_Jan_April_2025/Undergraduate/BSDS_2_Big Data Analytics/Datasets")
library(readxl)
library(dplyr)
library(tidyverse)
exercise1 = read_excel("Student_performance.xlsx")
summary(exercise1)
end_time = proc.time()
end_time - start_time
#Result: The above takes 14.456 seconds


##2.USING THE PISA DATASET##
#A. The 2015-2022 administration of PISA involves more than 540,000 students, teachers, parents from 72 participating countries and economies.
#https://www.oecd.org/en/data/datasets/pisa-2015-database.html#data (Rescalled indices for 2022 – 77.3 MB)


#B. Importing the "escs_trend.csv" dataset
exercise2=read.csv("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Easter_Jan_April_2025/Undergraduate/BSDS_2_Big Data Analytics/Datasets/escs_trend/escs_trend.csv")
#Result: The dataset has 1,447,787 observations and 10 variables

#C. Let's get some descriptive stats
summary(exercise2)


##3. Data wrangling using data.table##
#A. Recall the DT code is written as:
DT[i,
   j,
   by]
#where i=manipulates rows
#j=manipulates columns/variables
#by= group by
#Install the data.table package
install.packages("data.table")
library(data.table)


##B. Why choose data.table over tidyverse?
#let's look at the processing time for importing our dataset using both packages
#Time for importing using read.csv
system.time({read.csv("escs_trend/escs_trend.csv")})
#Result:6.581 seconds

#Time when using data.table
system.time({fread("escs_trend/escs_trend.csv", na.strings = "")})
#Result: 0.134 seconds


##C. Importing and reading data using data.table
exercise3 = fread("escs_trend/escs_trend.csv", na.strings = "")
#To see the class object that dataset is
class(exercise3)
#To see the size of the dataset
print(object.size(exercise3), unit = "MB")  #Unit can be KB, MB or GB or TB
#Result: 88.4MB

#If we want to save the data in another format e.g. excel
fwrite(exercise3, file = "newfile.xlsx")



##D. subsetting dataset for better handling
#let's subset data based on the PISA cycle (cycle 05=PISA 2012; cycle 06=PISA 2015; cycle 07=PISA 2018).

#Generating a csv file for cycle 5
cycle5 = subset(exercise3, cycle %in%  ("5"))
#Save the subsetted data as a csv file
fwrite(cycle5, file = "cycle5.csv")
#Result: This file has 453,304 observations, 10 variables

#Exercise:
#subset the data for cycle 6 and cycle 7.


##E. Using the "i" in the data.table code
#For instance using our cycle5 data, we want to know the count of respondents from a country called "MEX"
#First we import our subsetted data
cycle5 = fread("cycle5.csv", na.strings = "")
#Then select only data from country MEX
cycle5[cnt == "MEX"]
#Let's output the result in to an object called mexico
mexico=cycle5[cnt == "MEX"]
#Result: 33,806 respondents.

#how many respondents are from MEX and have a paredint_trend of 16?
mexico2=cycle5[cnt == "MEX" & paredint_trend == 16]
#Result: 7,863 respondents

#Subsetting a few rows e.g. rows 3-100
cycle5[3:100,]
#OR
cycle5[3:100]
setwd(C:\Users\RONALD TUSIIME KIGAM\Desktop\Big Data Analytics (R))

