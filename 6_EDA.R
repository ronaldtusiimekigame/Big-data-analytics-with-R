#### EXPLORATORY DATA ANALYSIS ######
#EDA involves the exploration of data to obtain insights using:
#1. Statistical methods such as summary statistics
#2. Visualization of the data
#3. Data analysis to address exploratory questions
dbitalo@ucu.ac.ug
#Set the working directory
setwd("~/Desktop/Work/Documents/Personal Learning/UCU Classes/Trinity_May_Aug_2024/Undegraduate/BSC Data Science_Trinity_2024/Practicals")
# Load the dataset Bike_Sales
Data = readxl::read_xlsx("Bike_Sales.xlsx")
#View first 10 rows of dataset
head(Data, n=10)

#####Steps in Exploratory Data Analysis ####

###A. Explore Data Structure ###
library(tidyverse) #For data exploration and transformation. Also includes the library dplyr
install.packages("DT")
library(DT) #Displays data as data tables
datatable(data = Data)
#To view the columns and rows in the dataset
str(Data)
dim(Data) #Shows number of rows and columns
#To view the data types of each variable/column
sapply(Data,class)
#Result: 8 variables are characters or categorical
#The variable Month is also ordinal as it is in order (January to December)
#However, the other categorical variables are not ordinal (are nominal)
#We will thus treat these variables as factors (or categorical variable)
Data$Month = as.factor(Data$Month)
Data$Age_Group = as.factor(Data$Age_Group)
Data$Customer_Gender = as.factor(Data$Customer_Gender)
Data$Country = as.factor(Data$Country)
Data$State = as.factor(Data$State)
Data$Product_Category = as.factor(Data$Product_Category)
Data$Sub_Category = as.factor(Data$Sub_Category)
Data$Product = as.factor(Data$Product)
#View datatypes again
sapply(Data,class)


###B. Transform the Dataset ########
##1. Handling Missing Data
#Check for missing data
sum(is.na(Data))
#Result: No missing data



#####C. Measure the Central Tedency #####
##1. Measure central tendency using descriptive stats
summary(Data)
#For more detailed stats use the describe() function
#The function is under the packages Hmisc and even dlookr 
install.packages("Hmisc")
install.packages("dlookr")
library(Hmisc)
library(dlookr)
describe(Data)
#The IQR values are also generate using describe() function
#We can output the result
result_descriptive = describe(Data)
#skewness: The left-skewed distribution data, with significant positive skewness, 
#should be transformed to follow the normal distribution. 
#Skewness can also be checked using dplyr
library(dplyr)
Data %>%
  describe() %>%
  select(described_variables, skewness) %>% 
  filter(!is.na(skewness)) %>% 
  arrange(desc(abs(skewness)))
#Rules of skewness:
#-0.5 to 0.5 = normal distribution
#-1 to -0.5 (negative skewed) or 0.5 to 1(positive skewed) indicate slightly skewed data distributions.
#values less than -1 (negative skewed) or greater than 1 (positive skewed) are considered highly skewed.
#Therefore, variables from Unit_Cost to Revenue are positively skewed


##2. Measure central tendency using visuals
#We could use boxplot
library(ggplot2)
ggplot(data = Data, mapping = aes(y = Unit_Price)) +
  geom_boxplot() +
  labs(y="Unit Price", 
       title="Distribution of Bike Sales Unit Price")

#We could use a histogram for continuous variables
ggplot(data = Data, aes(x = Revenue)) +
  geom_histogram() +
  labs(x="Revenue", 
       title="Distribution of Bike Sales Revenue")

#Use a barplot to show distribution of categorical variables
ggplot(data = Data, aes(x = Age_Group)) +
  geom_bar() +
  labs(x="Age Groups", 
       title="Distribution of Customer Age Groups")
#We could also count the categories in age groups
Data %>% 
  count(Age_Group)
#Result: The customers who are Adults have the highest bike sales (55824)


#3. Measure central tendency using normality tests
#Use a Shapiro-Wilk test for samples not more than 5,000
#Use a K-S (Kolmogorov-Smirnov) test for samples more than 5,000
#Normality can be plotted using Q-Q plots
plot_normality(Data, Revenue)
#This generates four graphs
#Null: No persons above 50 (p=<0.05). Reject null hpothesis. If p=0.04. There are 
#Alternative: Persons above 50. If p>0.05, accept null hypothesis

#To run the Statistical test since our data has >5,000 observations
normality(Data)
normal_distribution =normality(Data)
#The above gives a statistic, p-value and number of samples.
#The test only manages to analyse 5,000 samples
#Null hypothesis: the data are normally distributed
# Alternative hypothesis: the data are not normally distributed
# p-value =<0.05 are not normally distributed, 
#p-value >= 0.05 are normally distributed
shapiro.test(Data$Revenue)
#Notice the Shapiro test gives an error because of the big sample number

#So we use the Kolmogorov-Smirnov (K-S) test
install.packages("dgof")
library(dgof)
ks.test(Data$Revenue, "pnorm")
#Result: D = 0.99602, p-value < 2.2e-16 (less than 0.05)
#Therefore, the Revenue is not normally distributed.



######D. Handling Outliers ####
#1. Find the IQR of numeric variables
IQR_results = Data %>%
  describe() %>%
  select(described_variables, IQR) %>% 
  filter(!is.na(IQR)) %>% 
  arrange(desc(abs(IQR)))

##2. Get threshold values for the variable Revenue
#Tmin = Q1 - (1.5*IQR)
#Tmax = Q3 + (1.5*IQR)
Tmin_rev = 70-(1.5*810) 
Tmax_rev = 880+(1.5*810) 

##3. Find the outliers
Outliers_Revenue = Data$Revenue[which(Data$Revenue < Tmin_rev | Data$Revenue > Tmax_rev)]
#View the outliers
Outliers_Revenue

##Handle outliers in all 6 skewed variables
# create a detect outlier function
detect_outlier <- function(x) {
  
  # calculate first quantile
  Quantile1 <- quantile(x, probs=.25)
  
  # calculate third quantile
  Quantile3 <- quantile(x, probs=.75)
  
  # calculate inter quartile range
  IQR = Quantile3 - Quantile1
  
  # return true or false for outliers
  x > Quantile3 + (IQR * 1.5) | x < Quantile1 - (IQR * 1.5)
}

# create a remove outlier function
remove_outlier <- function(dataframe, columns = names(dataframe)) {
  
  # for loop to traverse in columns vector
  for (col in columns) {
    
    # remove observation if it satisfies outlier function
    dataframe <- dataframe[!detect_outlier(dataframe[[col]]), ]
  }
  
  # return dataframe
  print("Remove outliers")
  print(dataframe)
}

Data_new = remove_outlier(Data, c('Customer_Age', 'Unit_Cost', 'Unit_Price', 'Profit', 'Cost', 'Revenue'))

##The new dataset has 69,407 observations versus the old one with 113,036 observations



###D. Save the transformed dataset
##1. Save as csv
write.csv(Data_new, file = "Bike_Sales_New.csv")

##2. Save as an excel file
install.packages("WriteXLS")
library(WriteXLS)
WriteXLS(Data_new, ExcelFileName = "Bike_Sales_New.xlsx",
         SheetNames = "Sales",
         AdjWidth = T,
         BoldHeaderRow = T)




#### E. Addressing Exploratory Questions ###
##1. Relationships between continuous variables
#Using visuals (scatterplots)
ggplot(data = Data_new, mapping = aes(x = Year, y = Revenue)) + 
  geom_point() +
  labs(x="Year", 
       y="Revenue",
       title="Bike Sales Revenue Per Year")

#Compare the result to the raw data you had not transformed
ggplot(data = Data, mapping = aes(x = Year, y = Revenue)) + 
  geom_point() +
  labs(x="Year", 
       y="Revenue",
       title="Bike Sales Revenue Per Year")

#Checking relationships using statistics



##2. Relationships between categorical and continuous variables
#Using visuals (Boxplot)
ggplot(data = Data_new, mapping = aes(x = Product_Category, y = Profit)) +
  geom_boxplot() +
  labs(x="Product Category", 
       y="Profit",
       title="Profits Generated by Product Categories")

#Using visuals (frquency line graph)
ggplot(data = Data_new, mapping = aes(x = Profit)) + 
  geom_freqpoly(mapping = aes(colour = Country), binwidth = 500) +
  labs(x="Profit", 
       title="Profits Generated by Country")



##3. Relationships between categorical variables
#Visuals (count graph)
ggplot(data = Data) +
  geom_count(mapping = aes(x = Age_Group, y = Country)) +
  labs(x="Age Groups", 
       y="Country",
       title="Age Groups Purchasing Bikes across Countries")

#Visuals (Heatmap)
Data_new %>% 
  count(Age_Group, Country) %>%  
  ggplot(mapping = aes(x = Age_Group, y = Country)) +
  geom_tile(mapping = aes(fill = n))  +
  labs(x="Age Groups", 
       y="Country",
       title="Age Groups Purchasing Bikes across Countries")
