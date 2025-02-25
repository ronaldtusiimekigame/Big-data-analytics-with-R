############# R VISUALISATION EXERCISES #####################
#### R is a language which converts the Data into Art means that explain/visualize the data in the form of graphs/plots.

#1. Correlation

#The plots help to examine relationships between two/more variables are.


##1.  Scatterplot (Compares continuous variables)

#It can be drawn using geom_point().
#install.packages("ggplot2")
install.packages("ggplot2")
# load package and data
options(scipen=999)  # turn-off scientific notation like 1e+48
library(ggplot2)
theme_set(theme_bw())  # pre-set the bw theme.
data("midwest", package = "ggplot2")
#Alternatively get the midwest dataset by
ggplot2::midwest
?midwest
# midwest <- read.csv("http://goo.gl/G1K41K")  # bkup data source
save
# Scatterplot
scatterplot <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) + 
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot", 
       caption = "Source: midwest")

plot(scatterplot)

### Scatterplot With Encircling
#When presenting the results, sometimes I would encirlce certain special groups 
# install 'ggalt' pkg
# devtools::install_github("hrbrmstr/ggalt")
options(scipen = 999)
library(ggplot2)
install.packages("ggalt")
library(ggalt)
midwest_select <- midwest[midwest$poptotal > 350000 & 
                            midwest$poptotal <= 500000 & 
                            midwest$area > 0.01 & 
                            midwest$area < 0.1, ]

# Plot
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) +   # draw points
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) +   # draw smoothing line
  geom_encircle(aes(x=area, y=poptotal), 
                data=midwest_select, 
                color="red", 
                size=2, 
                expand=0.08) +   # encircle
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot + Encircle", 
       caption="Source: midwest")

# load ggplot2
library(ggplot2)
install.packages("hrbrthemes")
library(hrbrthemes)

# iris dataset is natively available in R
# head(iris)
datasets::iris
?iris

# A basic scatterplot with color depending on Species
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) + 
  geom_point(size=6) +
  theme_ipsum()


#2. Counts Chart
#This overcomes the problem of data points overlap is to use what is called a counts chart. 
#Whereever there is more points overlap, the size of the circle gets bigger.
# load package and data
#mpg dataset is also found in ggplot2
library(ggplot2)
data(mpg, package="ggplot2")

# Scatterplot
theme_set(theme_bw())  # pre-set the bw theme.
g <- ggplot(mpg, aes(cty, hwy))
g + geom_count(col="tomato3", show.legend=F) +
  labs(subtitle="mpg: city vs highway mileage", 
       y="hwy", 
       x="cty", 
       title="Counts Plot")


#3.### Correlogram
#Examines the corellation of multiple continuous variables present in the same dataframe. 
#This is conveniently implemented using the ggcorrplot package. 
# Libraries/packages
install.packages("ellipse")
install.packages("RColorBrewer")
library(ellipse)
library(RColorBrewer)

# Use of the mtcars data proposed by R
#Can be found at
datasets::mtcars
?mtcars
data <- cor(mtcars)

# Build a Pannel of 100 colors with Rcolor Brewer
my_colors <- brewer.pal(5, "Spectral")
my_colors <- colorRampPalette(my_colors)(100)

# Order the correlation matrix
ord <- order(data[1, ])
data_ord <- data[ord, ord]
plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1)  )

devtools::install_github("kassambara/ggcorrplot")
library(ggplot2)
library(ggcorrplot)

# Correlation matrix
data(mtcars)
corr <- round(cor(mtcars), 1)

# Plot
ggcorrplot(corr, hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method="circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title="Correlogram of mtcars", 
           ggtheme=theme_bw)


#4. WE can also generate a scatterplot of various variables
# Data: numeric variables of the native mtcars dataset
data <- mtcars[ , c(1,3:6)]

# Plot
plot(data , pch=20 , cex=1.5 , col="#69b3a2")


#5. A BAR PLOT
#This shows the distribution of categorical variables
# Data
data <- data.frame(
  name = c("DD","with himself","with DC","with Silur" ,"DC","with himself","with DD","with Silur" ,"Silur","with himself","with DD","with DC" ),
  average = sample(seq(1,10) , 12 , replace=T),
  number = sample(seq(4,39) , 12 , replace=T)
)

# Increase bottom margin
par(mar=c(6,4,4,4))


# Basic Barplot
my_bar <- barplot(data$average , border=F , names.arg=data$name , 
                  las=2 , 
                  col=c(rgb(0.3,0.1,0.4,0.6) , rgb(0.3,0.5,0.4,0.6) , rgb(0.3,0.9,0.4,0.6) ,  rgb(0.3,0.9,0.4,0.6)) , 
                  ylim=c(0,13) , 
                  main="" )

# Add abline
abline(v=c(4.9 , 9.7) , col="grey")

# Add the text 
text(my_bar, data$average+0.4 , paste("n: ", data$number, sep="") ,cex=1) 

#Legende
legend("topleft", legend = c("Alone","with Himself","With other genotype" ) , 
       col = c(rgb(0.3,0.1,0.4,0.6) , rgb(0.3,0.5,0.4,0.6) , rgb(0.3,0.9,0.4,0.6) ,  rgb(0.3,0.9,0.4,0.6)) , 
       bty = "n", pch=20 , pt.cex = 2, cex = 0.8, horiz = FALSE, inset = c(0.05, 0.05))

#6. Barplot with error bar
# Load ggplot2
library(ggplot2)

# create dummy data
data <- data.frame(
  name=letters[1:5],
  value=sample(seq(4,15),5),
  sd=c(1,0.2,3,2,4)
)

# rectangle
ggplot(data) +
  geom_bar( aes(x=name, y=value), stat="identity", fill="skyblue", alpha=0.5) +
  geom_crossbar( aes(x=name, y=value, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)

# line
ggplot(data) +
  geom_bar( aes(x=name, y=value), stat="identity", fill="skyblue", alpha=0.5) +
  geom_linerange( aes(x=name, ymin=value-sd, ymax=value+sd), colour="orange", alpha=0.9, size=1.3)


#7. # Deviation bars
#Compares variation in values between small number of items (or categories) with respect to a fixed reference.

## Diverging bars
#Diverging Bars is a bar chart that can handle both negative and positive values. This can be implemented by a smart tweak with geom_bar().
library(ggplot2)
theme_set(theme_bw())  

# Data Prep
data("mtcars")  # load data
mtcars$`car name` <- rownames(mtcars)  # create new column for car names
mtcars$mpg_z <- round((mtcars$mpg - mean(mtcars$mpg))/sd(mtcars$mpg), 2)  # compute normalized mpg
mtcars$mpg_type <- ifelse(mtcars$mpg_z < 0, "below", "above")  # above / below avg flag
mtcars <- mtcars[order(mtcars$mpg_z), ]  # sort
mtcars$`car name` <- factor(mtcars$`car name`, levels = mtcars$`car name`)  # convert to factor to retain sorted order in plot.

# Diverging Barcharts
ggplot(mtcars, aes(x=`car name`, y=mpg_z, label=mpg_z)) + 
  geom_bar(stat='identity', aes(fill=mpg_type), width=.5)  +
  scale_fill_manual(name="Mileage", 
                    labels = c("Above Average", "Below Average"), 
                    values = c("above"="#00ba38", "below"="#f8766d")) + 
  labs(subtitle="Normalised mileage from 'mtcars'", 
       title= "Diverging Bars") + 
  coord_flip()

##8. # Distribution
#When you have lots and lots of data points and want to study where and how the data points are distributed.

## Histogram
#By default, if only one variable is supplied, the geom_bar() tries to calculate the count. In order for it to behave like a bar chart, the stat=identity option has to be set and x and y values must be provided.
library(ggplot2)
theme_set(theme_classic())

# Histogram on a Continuous (Numeric) Variable
g <- ggplot(mpg, aes(displ)) + scale_fill_brewer(palette = "Spectral")

g + geom_histogram(aes(fill=class), 
                   binwidth = .1, 
                   col="black", 
                   size=.1) +  # change binwidth
  labs(title="Histogram with Auto Binning", 
       subtitle="Engine Displacement across Vehicle Classes")  


g + geom_histogram(aes(fill=class), 
                   bins=5, 
                   col="black", 
                   size=.1) +   # change number of bins
  labs(title="Histogram with Fixed Bins", 
       subtitle="Engine Displacement across Vehicle Classes") 


#9. Display distribution of categorical variables using barplots
library(ggplot2)
theme_set(theme_classic())

# Barplot on a Categorical variable
g <- ggplot(mpg, aes(manufacturer))
g + geom_bar(aes(fill=class), width = 0.5) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Barplot on Categorical Variable", 
       subtitle="Manufacturer across Vehicle Classes") 

#10 Density Plots
#Density plots can also be used to display distribution
library(ggplot2)
theme_set(theme_classic())

# Plot
g <- ggplot(mpg, aes(cty))
g + geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")

#11. Boxplots
#Great for studying distribution and displaying outliers
library(ggthemes)
g <- ggplot(mpg, aes(class, cty))
g + geom_boxplot(aes(fill=factor(cyl))) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Box plot", 
       subtitle="City Mileage grouped by Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")

#12. PieCharts
#Shows composition of groups/samples by displaying the frequency
library(ggplot2)
ggplot2::mpg
?mpg
theme_set(theme_classic())

# Source: Frequency table
df <- as.data.frame(table(mpg$class))
colnames(df) <- c("class", "freq")
pie <- ggplot(df, aes(x = "", y=freq, fill = factor(class))) + 
  geom_bar(width = 1, stat = "identity") +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="class", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of class of car", 
       caption="Source: mpg")

pie + coord_polar(theta = "y", start=0)


#14. Seasonal Plots
#Great for if you're working with time series data
#Use the example of the "Air Passengers" dataset
datasets::AirPassengers
library(ggplot2)
install.packages("forecast")
library(forecast)
theme_set(theme_classic())

# Subset data 
nottem_small <- window(nottem, start=c(1920, 1), end=c(1925, 12))  # subset a smaller timewindow

# Plot
ggseasonplot(AirPassengers) + labs(title="Seasonal plot: International Airline Passengers")



####15. ## Map ploting...

# Leaflet package offers several tiles to customize the background used on a map.

#A tile can be loaded thanks to the addProviderTiles() function.
install.packages("leaflet")
# Load the library
library(leaflet)

# Background 1: Import a NASA map
m <- leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>% 
  addProviderTiles("NASAGIBS.ViirsEarthAtNight2012")
m

# Background 2: World Imagery
m <- leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 3 ) %>% 
  addProviderTiles("Esri.WorldImagery")
m
#save the plot
htmlwidgets::saveWidget(m, "map_plot.html")

#Then use bubbleplot on the map
# Load libraries
library(leaflet)

# Make data with several positions
data_red <- data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Red_place_",seq(1,10)))
data_blue <- data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Blue_place_",seq(1,10)))

# Initialize the leaflet map:
m <- leaflet() %>% 
  setView(lng=42, lat=23, zoom=6 ) %>%
  
  # Add two tiles
  addProviderTiles("Esri.WorldImagery", group="background 1") %>%
  addTiles(options = providerTileOptions(noWrap = TRUE), group="background 2") %>%
  
  # Add 2 marker groups
  addCircleMarkers(data=data_red, lng=~LONG , lat=~LAT, radius=8 , color="black",
                   fillColor="red", stroke = TRUE, fillOpacity = 0.8, group="Red") %>%
  addCircleMarkers(data=data_blue, lng=~LONG , lat=~LAT, radius=8 , color="black",
                   fillColor="blue", stroke = TRUE, fillOpacity = 0.8, group="Blue") %>%
  
  # Add the control widget
  addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("background 1","background 2"), 
                   options = layersControlOptions(collapsed = FALSE))

m
#save the plot
htmlwidgets::saveWidget(p, "map_bubble.html")

#Plot the map using "map" package
# Load libraries
library(leaflet)

# Make data with several positions
data_red <- data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Red_place_",seq(1,10)))
data_blue <- data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Blue_place_",seq(1,10)))

# Initialize the leaflet map:
m <- leaflet() %>% 
  setView(lng=42, lat=23, zoom=6 ) %>%
  
  # Add two tiles
  addProviderTiles("Esri.WorldImagery", group="background 1") %>%
  addTiles(options = providerTileOptions(noWrap = TRUE), group="background 2") %>%
  
  # Add 2 marker groups
  addCircleMarkers(data=data_red, lng=~LONG , lat=~LAT, radius=8 , color="black",
                   fillColor="red", stroke = TRUE, fillOpacity = 0.8, group="Red") %>%
  addCircleMarkers(data=data_blue, lng=~LONG , lat=~LAT, radius=8 , color="black",
                   fillColor="blue", stroke = TRUE, fillOpacity = 0.8, group="Blue") %>%
  
  # Add the control widget
  addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("background 1","background 2"), 
                   options = layersControlOptions(collapsed = FALSE))

m
#save the plot
htmlwidgets::saveWidget(p, "map_bubble.html")
