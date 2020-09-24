#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#-

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.--------------------
#----------------------

#------------------
# Lets get started!
#------------------
install.packages("tidyverse")
library(tidyverse)
#dplyr and tidyr

#Load the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")
surveys

# check structure
str(surveys)

#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
# select three colums:
select(surveys, plot_id, species_id, weight)

#exclude two columns:
select(surveys, -plot_id, -species_id)

#filter for a particular year
surveys_1995 <- filter(surveys, year == 1995)

#<- is assignment sign

surveys2 <- filter (surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

#combine the above two:
surveys_sml <- select(filter (surveys, weight < 5), species_id, sex, weight)

#-------
# Pipes
#3.1 %>% 向右操作符(forward-pipe operator)

#%>%是最常用的一个操作符，就是把左侧准备的数据或表达式，传递给右侧的函数调用或表达式进行运行，可以连续操作就像一个链条一样。
#-------
#The pipe --->   %>%
  # shortcut: ctrl + shift + m or command + shift + m
  surveys_sml <- surveys %>%
  filter(weight < 5)%>%
  select(species_id, sex, weight)

surveys_sml2 <- surveys %>%
select(species_id, sex, weight)%>%
filter(weight < 5)
# weight will be missing?

test <- surveys %>%
  select (species_id, sex)

#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.
survey_1995 <- surveys %>%
  filter(year<1995) %>% 
  select(year, sex, sex)




#--------
# Mutate
#--------

#creat a new column and keep the orignal column
surveys_weights <- surveys %>% 
  mutate(weight_kg = weight/1000)

mutate(weight_kg = weight/1000,
       weight_lb = weight_kg*2.2) %>% 
  view(surveys_weights)

tail(surveys_weights)


surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  head(20)
filter(length !="")

#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!
#answer:
surveys_new <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length/10) %>% 
  filter(hindfoot_cm <3) %>% 
  select(species_id, hindfoot_cm)

view(surveys_new)

tail(surveys_new)
str(surveys_new)
length(surveys_new)
summary(surveys_new)

#my sollution:
  
surveys_new2 <- surveys %>% 
  mutate(hindfoot_cm = hindfoot_length/10) %>% 
  filter(hindfoot_cm <3, !is.na(hindfoot_cm)) %>% 
  select(species_id, hindfoot_cm)
view(surveys_new2)


#---------------------
# Split-apply-combine
#---------------------
surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

summarise(surveys)
# 不能用于不同种类的数据?
?summarise


#try:
surveys %>% 
  dplyr::group_by(sex)


summary(surveys)
length(surveys)

surveys$sex <- as.factor(surveys$sex)
view(surveys$sex)


surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  # head or tail()
  print(n = 20)

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(min_weight) #from small to large


surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
arrange(mean_weight)
# or arrange(mean_weight)

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(desc(min_weight)) #from large to small
?arrange
# or use: arrange(-min_weight) #from large to small

surveys %>% 
  count(sex)

#or use:
  surveys %>% 
  group_by(sex) %>% 
  summarise(count = n())

  
  surveys %>% 
    group_by(sex, species, taxa) %>% 
    summarise(count = n())

 # From Jonathon Mifsud to Everyone:  11:17 AM
  #Hi Evan, when using group_by(), what if I would like to group by a second variable (e.g. species_id) further down in the pipeline but not continue to group by the first variable (e.g. sex)
  surveys_new <- surveys %>% 
    group_by(sex, species, taxa) %>% 
    summarise(count = n()) %>% 
    ungroup()
  
  surveys_new %>% 
    summarise(mean_weight = mean(weight))
  
  #上面两没弄懂
  
#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?


  
  surveys %>% 
    count(plot_type)
  
  # more official way:
  num_animal <- surveys %>% 
    group_by(plot_type) %>% 
    summarise(count = n())
  
# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

  hindfoot_info <- surveys %>% 
    filter(!is.na(hindfoot_length)) %>% 
    group_by(species_id) %>% 
    summarise(mean_hindfoot = mean(hindfoot_length),
              min_hindfoot = min(hindfoot_length),
              max_hindfoot = max(hindfoot_length),
              count = n())
  
# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.

heaviest_year <- surveys %>% 
  select(year, genus, species_id, weight) %>% 
  group_by(year) %>% 
  summarise(max_weight = max(weight), na.rm = TRUE)

#solution:
  heaviest_year <- surveys %>% 
    select(year, genus, species_id, weight) %>% 
    group_by(year) %>% 
    mutate(max_weight = max(weight, na.rm = TRUE)) %>% 
  ungroup()
#ungroup在我这里无效
  
  #From Belinda Fabian (Instructor) to Everyone:  11:44 AM
 # Here’s another solution (better results)
  heaviest_year2 <- surveys %>%
    filter(!is.na(weight)) %>%
    group_by(year) %>%
    filter(weight == max(weight)) %>%
    select(year, genus, species, weight) %>%
    arrange(year)
 ? distinct()

  
#-----------
# Reshaping
#-----------

surveys_gw <- surveys %>% 
    filter(!is.na(weight)) %>% 
    group_by(plot_id, genus) %>% 
    summarise(mean_weight = mean(weight))
  
surveys_wider <- surveys_gw %>% 
  spread(key = genus, value = mean_weight)

str(surveys_wider)


surveys_gather <- surveys_wider %>% 
  gather(key = genus, value = mean_weight, -plot_id)
#remove plot_id from genu

surveys_gather2 <- surveys_wider %>% 
  gather(key = genus, value = mean_weight, Baiomys:Spermophilus)
# in order of Baiomys:Spermophilu

#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

surveys_spread_genera <- surveys %>% 
  group_by(plot_id, year) %>% 
  summarise(n_genera = n_distinct(genus)) %>% 
  spread(year, n_genera)

head(surveys_spread_genera)

# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

surveys_spread_genera2 <- surveys_spread_genera %>% 
gather(key = year, value = n_genera, -plot_id)


# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

surveys_long <- surveys %>% 
  gather("measurement", "value", hindfoot_length, weight)

head(surveys_long)

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().

surveys_long2 <- surveys_long %>% 
  group_by(year, measurement, plot_type) %>% 
  summarise(mean_value = mean(measurement, na.rm = TRUE)) %>% 
  spread(measurement, mean_value) %>% 
  
  head(surveys_long2)
tail(surveys_long2)



#----------------
# Exporting data
#----------------
write_csv(surveys_long, path = "data_out/surveys_long.csv")


#Belinda 讲解了pivot_longer(!plot_id, names_to = "genus", values_to = "mean_weight")
#pivot_wider()







