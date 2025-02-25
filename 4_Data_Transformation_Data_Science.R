################## *3. DATA TRANSFORMATION* ########################
####  Correcting data using the dplyr package
#setwd
# Confirm working directory (> getwd)
# Install and upload packages
install.packages("tidyverse")
install.packages("nycflights13") #Contains the dataset "flights"
library(tidyverse)
library(nycflights13)
## Explore the flight data under the package nycflights13
nycflights13::flights
?flights
view(flights)
str(flights) ##To see numerical, character, integer catagories of the variables

##### 3.1 DPLYR BASICS #####
# Pick observations by their values (filter()).
# Reorder rows (arrange()).
# Pick variables by their names (select()).
# Create new variables with functions of existing variables (mutate()).
# Collapse many values down to a single summary (summarise()).
# All functions be used in conjunction with group_by()

#### 3.2. FILTERING ROWS ########################
## E.g. select all flights on January 1st
filter(flights, month == 1, day == 1)
## Save the result as an object called "jan1"
jan1 <- filter(flights, month == 1, day == 1)
(jan1 <- filter(flights, month == 1, day == 1))
## R provides the standard suite of mathematical functions
# to use with filter: >, >=, <, <=, != (not equal), and == (equal)
# Use the "near" function for floating point numbers. See example
sqrt(2) ^ 2 == 2
## This returns a false response because sqrt of 2 = 1.4142135... has too many decimals
# So to make it work, use the "near" function for equating
near(sqrt(2) ^ 2, 2)
# Boolean operators can also be used with filter:
# & is “and”, | is “or”, and ! is “not”.
# To select flights that departed in November or December, use:
filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))
# To save the result:
nov_dec <- filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
# To find flights that were not delayed (on arrival/departure) by more than 2 hours
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
# To save the result:
delay <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
delay <- filter(flights, arr_delay <= 120, dep_delay <= 120)
# Determining missing data before filtering for it
is.na(flights)
# Save result 
df <- is.na(flights)

#### QUESTIONS #######
# Find all flights that;
#1. Had an arrival delay of two or more hours
#2. Flew to Houston (IAH or HOU)
#3. Were operated by United, American, or Delta
#4. Departed in summer (July, August, and September)
#5. Arrived more than two hours late, but didn’t leave late
#6. Were delayed by at least an hour, but made up over 30 minutes in flight
#7. Departed between midnight and 6am (inclusive)
#8. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?
#9. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?


##### 3.3. CHANGING ROWS WITH ARRANGE () ##########
# arrange() reorders rows by taking a data frame and a set of column names
arrange(flights, year, month, day)
# Use desc() to re-order by a column in descending order:
arrange(flights, desc(dep_delay))


#### 3.4. SELECT COLUMNS WITH SELECT #####
select(flights, year, month, day)
# Select all columns from year to day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day
select(flights, -(year:day))
#select() can be used to rename variables, but it’s rarely useful because it drops all of the variables not explicitly mentioned. Instead, use rename()
rename(flights, tail_num = tailnum)
# Another option is to use select() in conjunction with the everything() helper to move a handful of variables to the start of the data frame
select(flights, time_hour, air_time, everything())


###### 3.5. ADD VARIABLES WITH MUTATE() #######
# Adds new columns at the end of your dataset that are functions of existing columns
#The easiest way to see all columns is with view()
view(flights)
#Select columns year-day, delays, distance and air_time and call the output flights_sml
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
##Add the columns "gain" (dep_delay-arr_delay) and "speed" (distance/air_time * 60) and name the output an object flights_sml2:
flights_sml2 <- mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)
#The above code also has the innate R calculations in it.
# You can add more columns to the ones you've created
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)
# If you only want to keep the new colums use transmute ()
transmute(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)


####### 3.6. GROUP WITH SUMMARISE () ###########
##It collapses a data frame to a single row:
#To summarise the mean departure delay time excluding rows with missing data
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
#rm is remove, na is missing data, TRUE will allow removal of missing data.

#summarise() isn't very useful unless its paired it with group_by()
#E.g. Apply the previous code to a data frame grouped by date, to get the average delay per date:
# The grouped output is called "by_day"
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
# Save the output as "delay_by_day"
delay_by_day <- summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


##########  3.6.1 COMBINING CODES WITH PIPES ###############
# For instance to explore the relationship between the distance and average flight delay for each location/destination
# There are three steps to prepare this data:
#1. Group the flights by destination. Output labelled "by_dest"
by_dest <- group_by(flights, dest)
#2. Summarise to compute distance, average arrival delay, and number of flights. Output is labelled "delay"
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
#3. Filter to remove noisy points (prior to plotting), destinations with more than 20 flights (>20) and Honolulu airport, which is almost twice as far away as the next closest airport.
#Call output "delay2"
delay2 <- filter(delay, count > 20, dest != "HNL")
#4. Plot the results to see relationships/patterns
ggplot(data = delay2, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
# Graphical aesthetics can be changed from size to colour
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(colour = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
# However, the entire first 3 codes can be piped;
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

### 3.6.2 Ungrouping variables####
# Use the ungroup() function to reverse grouping
daily %>%
  ungroup() %>% # no longer grouped by date
  summarize(flights = n()) # all flights