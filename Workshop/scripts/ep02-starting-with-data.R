#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

url is arguments
destfile is desktop file source
a whole bunch of ..
34786 obs. of 13 variables
observations

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it
surveys
head(surveys)
View(surveys)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)


# ok - so what are dataframes ?

str(surveys)

#int: introduce
dim(surveys)
nrow(surveys)
# number of rows
ncol(surveys)
head(surveys)
tail(surveys)

#tail can be used to check the end of table to make sure there is no trash data.

head(surveys,20)
tail(surveys, 5)

tail(surveys)

names(surveys)
# names of columns
rownames(surveys)
summary(surveys)
# --------
# Exercise
# --------
#
# What is the class of the object surveys?
#
# Answer:
data.frame

# How many rows and how many columns are in this survey ?
#
# Answer:
34786
13

# What's the average weight of survey animals


# Answer:
summary(surveys)
42.67
# Are there more Birds than Rodents ?
#
#
# Answer:
summary(surveys)
No

# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1,1]
surveys[1,6]
#[row number, column number]


# first element in the 6th column (as a vector)
surveys[,6]
surveys[,8]
# first column of the data frame (as a vector)
surveys[,1]

# first column of the data frame (as a data frame)
surveys[1]
head(surveys[1])
if 
head(surveys[,1])
the following is my solution:
  data.frame(surveys[,1])

# first row (as a data frame)
surveys[1,]

my solution:
  data.frame(surveys[1,])

# first three elements in the 7th column (as a vector)
surveys[1:3,7]
my solution:surveys[c(1,2,3),7]

# the 3rd row of the data frame (as a data.frame)

surveys[3,]
my solution:
  data.frame(surveys[3,])

# equivalent to head(surveys)
head(surveys)
surveys[1:6,]
# looking at the 1:6 more closely
1:6
4:9
surveys[c(1,5,7),] #pick data


# we also use other objects to specify the range

rows <- 6

surveys[1:rows,3]
#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
surveys[34781:34786,]
best solution:
  nrow(surveys)
surveys[(nrow(surveys)-5):nrow(surveys), ]

or use:
  end<-length(surveys[,1]) #first colum

surveys[(end-5):end,]

# We can omit (leave out) columns using '-'
surveys[-1]
head(surveys[c(-1,-2,-3)])
head(surveys[-(1:3)])
-(1:3)
head(surveys[-1:3]) # wrong

# column "names" can be used in place of the column numbers
surveys["month"]
head(surveys["month"]) # only the first 6


#
# Topic: Factors (for categorical data)
#
#eg: 
# ranking: high medium lower
# likerty scales: very likely, neutral, unlikely, etc.
# country: Au, NZ, US

gender <- c("male", "male", "female")
gender <- factor (c("male", "male", "female"))
gender
class(gender)
levels(gender)
nlevels(gender)

# factors have an order
temperature <- factor (c("hot", "cold","warm", "hot"))
temperature[1]

temperature <- factor (c("hot", "cold","warm", "hot"))
temperature[3]
temperature
levels(temperature) #results: alphabetical
#to define the level manually:
temperature <- factor (c("hot", "cold","warm", "hot"), 
                       level = c("cold","warm", "hot"))
levels(temperature)

temperature <- factor (c("hot", "cold","warm", "hot"), 
                       level = c("cold","
                                 warm", "hot")) # can still run, but not readable

levels(temperature)




# Converting factors
as.numeric(temperature)
as.character(temperature) 

# can be tricky if the levels are numbers
year <- factor (c (1988, 1985, 1999) )
year
as.numeric(year)
as.character(year)
as.numeric(as.character(year))

# so does our survey data have any factors
str(surveys)

#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...

#packages
library(lubridate)

my_date<-ymd("2015-01-02")
my_date
class(my_date)

#date: 7-16-1977

# R can concatenated things together using paste()
paste("ab", "12", "4f")
paste("ab", "12", "4f", sep = "-")

paste("1995","01", "15", sep="-")

my_date <- ymd(paste("1995","01", "15", sep="-"))
my_date
class(my_date)

# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns
surveys$year
surveys_date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))
129 failed to parse.
# meaning: some date cannot be converted to date-because some months don't have 31 days.

summary(surveys$date)
missing_date <- surveys [is.na(surveys$date), "date"]
missing_date

missing_date <- surveys [is.na(surveys$date), c("date","year", "month", "day")]
missing_date
summary(missing_date)

missing_date <- surveys [is.na(surveys$date), c("record_id", "date","year", "month", "day")]
missing_date
summary(missing_date)




# let's save the dates in a new column of our dataframe surveys$date 


# and ask summary() to summarise 


# but what about the "Warning: 129 failed to parse"



today <- ymd ("2020-09-22")
yersterday <- ymd ("2020-09-21")

today
yersterday


# R resources: cloudstor.aarnet.edu.au
