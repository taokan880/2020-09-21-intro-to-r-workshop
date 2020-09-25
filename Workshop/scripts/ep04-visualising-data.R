# Visualising data with ggplot2

# load ggplot

library(ggplot2)
#older version ggplot

#load data

surveys_complete <- read.csv("data_raw/surveys_complete.csv")
# or read_csv (but a little different)

#or:
library(ggplot2)
library(tidyverse)
# will include ggplot2 package
surveys_complete <- read_csv("data_raw/surveys_complete.csv")


#create a plot
ggplot(data = surveys_complete)

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) + 
  geom_point()

# another way:----------------
# assign a plot to a object

surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))
surveys_plot

# draw the plot
surveys_plot +
  geom_point()
# "+" can be at the begining; wrong: 
# surveys_plot 
# + geom_point()


# Challenge 1
#Change the mappings so weight is on the y-axis and hindfoot_length is on the x-axis

ggplot(data = surveys_complete, mapping = aes(x = hindfoot_length, y = weight)) + 
  geom_point()

#From Maria (Helper) to Everyone:  09:52 AM
surveys_plot + 
  geom_point(aes(x = hindfoot_length, y = weight))
# global environment + modifications to overwrite


#Challenge 2
#How would you create a histogram of weights?
ggplot(data = surveys_complete, mapping = aes(x = weight)) + 
  geom_histogram() 

ggplot(data = surveys_complete, mapping = aes(x = weight)) + 
  geom_histogram(binwidth = 10) 

#From Katie Shead to Everyone:  09:55 AM
hist(surveys_complete$weight)



