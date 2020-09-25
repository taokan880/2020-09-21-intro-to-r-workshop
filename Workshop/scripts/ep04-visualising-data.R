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

# building plots iteratively
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1, colour = "turquoise")
#goole ggolot colour skins
#From Maria (Helper) to Everyone:  10:30 AM
#https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/
 # https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf
#There are also palettes that work both in color and black-and-white
#Also super useful for publications - you don't have to pay for coloured images

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1, aes(colour = species_id))

# or:
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length), colour = green) + 
  geom_point(alpha = 0.1)
#有问题？

#Challenge 3
#Use what you just learned to create a scatter plot of weight over species_id with the plot type showing in different colours. 

#Is this a good way to show this type of data?

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_jitter(alpha = 0.2, aes(colour = plot_type))

# boxplots
#one dicreste, one continuous
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_boxplot()

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, colour = "tomato")         

#my try:
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_boxplot(alpha = 0.2, aes(colour = plot_type))

#Challenge 4
#Notice how the boxplot layer is behind the jitter layer? What do you need to change in the code to put the boxplot in front of the points such that it’s not hidden?
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_jitter(alpha = 0.3, colour = "tomato") +
  geom_boxplot(alpha = 0)
         
# geom_boxplot(alpha = 0): non-transparent box

#Challenge 5
#Boxplots are useful summaries but hide the shape of the distribution. For example, if there is a bimodal distribution, it would not be observed with a boxplot. An alternative to the boxplot is the violin plot (sometimes known as a beanplot), where the shape (of the density of points) is drawn.

#Replace the box plot with a violin plot

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_violin(alpha = 1, colour = "tomato")
#alpha = 1: 100% normal

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) + 
  geom_jitter(alpha = 0.3, colour = "tomato") +
  geom_violin(alpha = 0)

#Challenge 6
#So far, we’ve looked at the distribution of weight within species. Make a new plot to explore the distribution of hindfoot_length within each species.
#Add color to the data points on your boxplot according to the plot from which the sample was taken (plot_id).

#Hint: Check the class for plot_id. Consider changing the class of plot_id from integer to factor. How and why does this change how R makes the graph?
  

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) + 
  geom_jitter(alpha = 0.3, colour = "tomato") +
  geom_boxplot(alpha = 0)

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) + 
  geom_jitter(alpha = 0.3, aes(colour = plot_id)) +
  geom_boxplot(alpha = 0)
# colour is only in a dreceasing way

#From Maria (Helper) to Everyone:  11:08 AM
#Change plot_id to a factor?
 # From Vera Horigue to Everyone:  11:08 AM
#Prefer to have totally different colours

class(surveys_complete$plot_id)

surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)
#will cahnge to factor permanently

class(surveys_complete$plot_id)

#solution:
  ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) + 
  geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
  geom_boxplot(alpha = 0)



# Challenge 7
#In many types of data, it is important to consider the scale of the observations. For example, it may be worth changing the scale of the axis to better distribute the observations in the space of the plot. Changing the scale of the axes is done similarly to adding/modifying other components (i.e., by incrementally adding commands). 
  ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) + 
    geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
    scale_y_log10()
# or
#scale_y_continuous(trans='log10')
  
  
  
  ggplot(surveys_complete, aes(species_id, hindfoot_length))+ geom_point()+scale_y_log10()
  
# plotting time series data
  # counts per year for eaach genus
  
  yearly_counts <- surveys_complete %>% 
    count(year, genus)
#From Richard Miller - Instructor to Everyone:  11:54 AM
#count(year, genus, name = "some_name") # Note the quotes (quotation marks)
  
  yearly_counts
  
  ggplot(data = yearly_counts, mapping = aes(year, n, group = genus)) +
    geom_line()

# if:  ggplot(data = yearly_counts, mapping = aes(year, n)) +
#  geom_line()
# Then: genus is not grouped
  
  
  # Challenge 8
  #
  # Modify the code for the yearly counts to colour by genus so we can
  # clearly see the counts by genus.
  
  ggplot(data = yearly_counts, mapping = aes(x=year, y=n, colour = genus)) +
    geom_line()
  # colour = genus自动先group
  
  
  # integrating the pipe ooperator with ggplot
  
yearly_counts_graph <- surveys_complete %>% 
count(year, genus) %>% 
ggplot(data = yearly_counts, mapping = aes(x=year, y=n, colour = genus)) +
  geom_line()

#faceting
ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(facets = vars(genus))
# vars: variables

yearly_sex_counts <- surveys_complete %>% 
  count(year, genus, sex)

yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus))
# colour = sex


yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_grid(rows = vars(sex), cols = vars(genus))
# two rows (based on sex)

yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_grid(rows = vars(genus))
# only one row



# Challenge 9
#
# How would you modify this code so the faceting is 
# organised into only columns instead of only rows?

yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_grid(cols = vars(genus))

# themes to change the elements in the graph

yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_wrap(~genus) +
  theme_bw()

# Challenge 10
#
# Put together what you’ve learned to create a plot that depicts how the 
# average weight of each species changes through the years.
#
# Hint: need to do a group_by() and summarize() to get the data
# before plotting

yearly_weight <- surveys_complete %>% 
  group_by(year, species_id) %>%
  summarise(mean_weight = mean(weight)) %>% 
  ggplot(mapping = aes(x = year, y = mean_weight, colour = species_id)) +
  geom_line() +
  facet_wrap(~species_id) +
  theme_classic()

# customisation
yearly_sex_counts %>% 
  ggplot(mapping = aes(x = year, y = n, colour = sex)) +
  geom_line() +
  facet_wrap(~genus) +
  labs(title = "Observed genra through time",
       x = "Year",
       y = "Number of indivdulas") +
  theme_bw() +
  theme(text = element_text(size = 8),
        axis.text.x = element_text(colour = "grey20",
                                   size = 8,
                                   angle = 90,
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.text = element_text(colour = "grey20",
                                 size = 8),
        strip.text = element_text(face = "italic")) +
  grey_theme

# exporting plots
ggsave("figures/my_plot.png", width = 15, height = 10)
#ggsave just save the only one graph most reently made.
?ggsave

ggsave("figures/my_plot.pdf", width = 15, height = 10)


#resources：
### 非常方面的图简介：help--cheatsheets--data visualisation with ggplot2
#MQ R users group

From Leanne Ruggero to Everyone:  12:56 PM
Looks like you can also just google ‘R cheatsheets’ to take you to the repository

