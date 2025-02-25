## ***HANDLING MISSING DATA AND OUTLIERS ** ##
#Install the package
install.packages("tidyverse")
install.packages("dplyr")
#libraries
library(readxl)
library(tidyverse)
library(dplyr) #USED FOR DATA TRANSFORMATION

#Set working directory
setwd("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Trinity_May_Aug_2024/Undegraduate/BSC Data Science_Trinity_2024/Practicals")

#Check your working directory
getwd()

#Import dataset as an R dataframe.
Happiness = read_xlsx("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Trinity_May_Aug_2024/Undegraduate/BSC Data Science_Trinity_2024/Practicals/Happiness_Score.xlsx")

#Viewing the structure of the datasets (i.e. columns, rows, and data types)
str(Happiness)

#We can also view the names of the variables (columns) in the dataset
names(Happiness)
#The names are too long and have spaces. Let's rename them
names(Happiness)[names(Happiness) == "`income (x$10,000)`"] = "income"
names(Happiness)[names(Happiness) == "`living costs (x$10,000)`"] = "living_costs"
names(Happiness)[names(Happiness) == "`happiness score (1-10)`"] = "happiness_score"
#We use the library tidyverse
library(tidyverse)
#To rename
Happiness_new = names(Happiness)[1] = "income"
Happiness_new = names(Happiness)[2] = "living_costs"
Happiness_new = names(Happiness)[3] = "happiness_score"
#View the result
names(Happiness)


##CENTRAL TENDENCY OF Data ##
summary(Happiness)
mean(Happiness) #This returns an error because we have missing data


# Check the dataset for missing values
is.na(Happiness) #This generates a "TRUE" result when there's missing data
sum(is.na (Happiness)) #This code sums up all the missing data
#R fails to see any missing values
#Alternative code 
sum(is.null(Happiness))

#Checking the particular variable with missing data
sum(is.null(Happiness$living_costs))
#We see R failing to pick up the missing data.


#So we extract the data from Happiness and create a new R dataframe
library(readxl) 

####IMPORTING A CSV FILE##
#Let's use a different dataset "Female_Mps.csv)

Data2 = read.csv("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Trinity_May_Aug_2024/Undegraduate/BSC Data Science_Trinity_2024/Practicals/Female_Mps.csv")
Data2
View(Data2)
#View the structure of Data2
str(Data2)

#Checking the mode of the variable "country"
#Mode is not inherently in R
#One has to generate a function for mode
getmode = function(v) {
  uniqv = unique(v) 
  uniqv[which.max(tabulate(match(v, uniqv)))]}
#Then use the function to calculate mode
v = Data2$country
mode_country = getmode(v)
mode_country
#Our mode is Afghanistan

#1. How much data is missing per variable? (If >30%, then you can omit it, if less than 30% then you do imputation)
sum(is.na(Data2))
#The dataset is missing 4389 observations

#HANDLING MISSING DATA ######
#Replace the missing values for continuous data using;mean or median
#Handling missing will vary for each column/variable (years)
sum(is.na(Data2$X1945))
#1945 has 167 missing observations
#If more than 30% of observations in one variable are missing, you delete the entire variable
#Or if you're certain about the variable, you can replace with a zero (0)

#1. Omit missing values if more than 30% of dataset in each variable.
#Lets create a new dataframe with omitted missing values
#We print the original dataframe before removal of missing data
print(Data2)
#The original dataset has 184 observations and 78 variables
#The print it after to compare
print("After removing the NA values ")
Data2_omit=na.omit(Data2)
print(Data2_omit)
#When we remove the missing data, we are left with 17 observations and 78 variables
#This implies we have lost alot of valuable data.
#So use imputation (replacing missing data using central tendency stats, or zeros)
#Let's first view which columns have 2 and more missing values
listMissingColumns = colnames(Data2)[ apply(Data2, 2, anyNA)]
print(listMissingColumns)
#The result shows all the columns are missing more than 2 values/observations
#Alternatively:
colSums(is.na(Data2)) #This shows even the number of missing data for each column

#2. To replace missing data using zero (This is if we are certain about the data)
#We need codes from the library (dplyr)
library(dplyr)
Data2_zero = Data2[is.na(Data2)] = 0
sum(is.na(Data2_zero))
#Now we have a new vector with no missing data
#This can alternatively be written as
Data2_zero = replace(Data2, is.na(Data2), 0)
#This produces a new dataframe with no missing data

#3. Replacing missing data with median (if not normally distributed)
#Viewing the distribution of our data in 2018
boxplot(Data2$X2018)
#The year 2018 is not normally distributed and has an outlier observation
#Further check it using summary statistics
summary(Data2$X2018)


#In case of missing observation, with none of the variables
#being normally distribute, we use median to impute
#The below code replaces for all numeric columns
Data2_imputed_median = Data2 %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))

#But to replace with median for only one column like 2018
Data2_median_2018 = Data2 %>% mutate(across(X1945, ~replace_na(., median(., na.rm=TRUE))))

# Alternative Imputing with median across all columns
Data2_impute_median_new = Data2 %>% 
  mutate_if(is.numeric, function(x) ifelse(is.na(x), median(x, na.rm = T), x))


#4.Replace missing data with mean (if it is normally distributed)
#Use the same codes as replacing with median.

###HANDLING OUTLIERS/ UNUSUAL DATAPOINTS####
#Detect outliers (unexpected pieces of information)
outliers_1945 <- boxplot.stats(Data2$X1945)$out  # outlier values in 1945
boxplot(Data2$X1945, main="Distribution of female politicians in 1945", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.6)
outliers_1945 <- boxplot.stats(Data2_imputed_median$X1945)$out
boxplot(Data2_imputed_median$X1945, main="Distribution of female politicians in 1945", boxwex=0.1)

#Outliers for the entire dataset
All_outliers <- boxplot.stats(Data2)$out
Data3=Data2[,-1]
boxplot(Data3, main="Representation from 1945-2021", boxwex=0.1)
mtext(paste("Outliers: ", paste(All_outliers, collapse=", ")), cex=0.6)

#Detect using histograms and Q-Q plots
#Histograms for continuous data
hist(Data2$X2021, main = "Distribution of Mps in 2021")
#Q-Q plot
qqnorm(Data2$X2021, main = "Distribution of Mps in 2021")

hist(Data$X1945, main = "Histogram")
qqnorm(Data$X1945, main = "Normal Q-Q plot")


# find outliers
Data$X1945[which(Data$X1945 < Tmin | Data$X1945 > Tmax)]
Sample_data$Price[which(Sample_data$Price < Tmin) | Sample_data$Price > Tmax]

# remove outliers using thresholds
Data$X1945[which(Data$X1945 > Tmin & Data$X1945 < Tmax)]

#Visualise the boxplot after outlier removal
boxplot(Data$X1945, main="Representation in 1945", boxwex=0.1)

### Removing outliers using IQR (Interquartile range)
# get values of Q1, Q3, 
summary(Data$X1945)

# get IQR
IQR(Sample_data$Price)
summary(Sample_data$Price)
#Result 6.46

# get threshold values for outliers
Tmin = 3.490-(1.5*6.46) 
Tmax = 9.950+(1.5*6.46) 

# find outliers
Outliers_price = Sample_data$Price[which(Sample_data$Price < Tmin | Sample_data$Price > Tmax)]
#Codes can be separately
Outlier_min = Sample_data$Price[which(Sample_data$Price < Tmin)]

#View outliers
Outliers_price
#Five outliers noticed (25.50, 33.22, 21.44, 27.99, 29.05)

#Remove the five outliers
Sample_data_no_outliers=Sample_data$Price[which(Sample_data$Price > Tmin & Sample_data$Price < Tmax)]
Sample_data_no_outliers

#To confirm removal of outliers use boxplot
boxplot(Sample_data$Price)


#If boxplot doesn't change, change the thresholds
#You can change them if you prior knowledge about what's expected
#We have no prior information, so we can keep the outliers as is




