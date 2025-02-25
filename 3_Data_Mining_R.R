######### DATA MINING ####
#To import data from an SQL server
#Packages to use
install.packages("DBI")
install.packages("odbc")
library(DBI)
library(odbc)

conn <- DBI::dbConnect(
  odbc::odbc(),
  Driver = "SQL Server",
  Server = "ServerName",
  Database = "DatabaseName",
  uid = "UserName",
  pwd = "Password",
  options(connectionObserver = NULL)
)

data <- dbGetQuery(conn, "SELECT * FROM ...")

#Importing from a url/website or called web-scrapping
#Packages to use (This is a bit long)
install.packages("rvest")
install.packages("readtext")
install.packages("webdriver")
install.packages("tidyverse")
install.packages("readtext")
install.packages("flextable")
webdriver::install_phantomjs()
# install klippy for copy-to-clipboard button in code chunks
install.packages("remotes")
remotes::install_github("rlesur/klippy")

#Call up the libraries
library(tidyverse)
library(rvest)
library(readtext)
library(flextable)
library(webdriver)
# activate klippy for copy-to-clipboard button
klippy::klippy()

#Define a url or webiste (We are searching for an article on the UCU website)
url = "https://ucu.ac.ug/food-waste-supply-in-kampala-city-uganda/"
# download content
webc <- rvest::read_html(url)
# inspect the content
webc
#This generates HTML data which may not be comprehensible.
#So we use the read_html to read the contents
webc %>%   # extracts paragraphs
rvest::html_nodes("p") %>%   #extracts text
rvest::html_text() -> webtxt
# inspect just the first 6 sentences
head(webtxt)
#Or inspect the entire article
webtxt


#####IMPORTING VARIOUS DATATYPES IN TO R ###
####Instell packages for common datatypes such as SPSS, Matlab, STATS, SAS
#And attach their dependency packages "dependency=T"
install.packages(c('quantmod','ff','foreign','R.matlab'),dependency=T)
library(quantmod)
library(ff) 
library(foreign)
library(R.matlab)
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tidyverse))

#1. Importing a CSV file in R
data1 <- read_csv('data/hotel_bookings_clean.csv',show_col_types = FALSE)
#Show the first 5 rows of the dataset
head(data1, 5)

#Or use the read.table function to load the file. 
data2 <- read.table('data/hotel_bookings_clean.csv', sep=",", header = 1)
head(data2, 5)


#2.Importing a TXT file in R
data3 <- read.delim('data/word_document.txt',header = F)
head(data3, 5)


#3.Importing data from Excel into R
library(readxl)
data4 <- read_excel("data/Tesla Deaths.xlsx", sheet = 1)
head(data4, 5)

#4. Importing data from a JSON file
library(rjson)
JsonData <- fromJSON(file = 'script.json')
print(JsonData[1])

#To convert the JSON data into an R dataframe, we will use data.table function
data5 = as.data.frame(JsonData[1])
data5


#5. Importing data from a Database using SQL in R
library(RSQLite)
conn <- dbConnect(RSQLite::SQLite(), "data/mental_health.sqlite")
dbListTables(conn)
# 'Answer''Question''Survey'

#To run a query and display the results, we will use the `dbGetQuery` function.
dbGetQuery(conn, "SELECT * FROM Survey")

#Convert the SQL into an R dataframe
data6 = dbGetQuery(conn, "SELECT * FROM Question  LIMIT 3")
data6

#6. Importing XML into R
library(xml2)
plant_xml <- read_xml('https://www.w3schools.com/xml/plant_catalog.xml')
plant_xml_parse <- xmlParse(plant_xml)

#Convert the XML data to an R data frame using the `xmlToDataFrame` function
plant_nodes= getNodeSet(plant_xml_parse, "//PLANT")
data9 <- xmlToDataFrame(nodes=plant_nodes)
head(data9,5)

#7. Importing HTML Table into R
library(XML)
library(RCurl)
url <- getURL("https://en.wikipedia.org/wiki/Brazil_national_football_team")
tables <- readHTMLTable(url)
data7 <- tables[23]
data7$`NULL`

#You can also use the rvest package to read HTML using URL
library(rvest)
url <- "https://en.wikipedia.org/wiki/Argentina_national_football_team"
file<-read_html(url)
tables<-html_nodes(file, "table")
data8 <- html_table(tables[25])
View(data8)


#8. Importing data from a SAS file
library(haven)

data10 <- read_sas('data/lond_small.sas7bdat')

# display data
head(data10,5)


#9. Importing data from a SPSS file
library(haven)

data11 <- read_sav("data/airline_passengers.sav")                       
head(data11,5)

#foreign package also allows you to load Minitab, S, SAS, SPSS, Stata, Systat, Weka, and Octave file formats. 
library("foreign")

data12 <- read.spss("data/airline_passengers.sav", to.data.frame = TRUE)
head(data12,5)


#10.Importing Stata Files into R
library("foreign")
data13 <- read.dta("data/friendly.dta")
head(data13,5)

#11. Importing Matlab Files into R
library(R.matlab)
data14 <- readMat("data/cross_dsads.mat")
head(data14$data.dsads)


