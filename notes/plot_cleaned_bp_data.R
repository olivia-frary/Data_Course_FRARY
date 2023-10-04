library(tidyverse)
library(GGally)
dat <- readRDS("./notes/cleaned_bp.rds")
names(dat)

# part of (GGally), gets an initial look at the data
# dat %>%
#   select(-c(pat_id, month_of_birth, day_birth, year_birth)) %>% 
#   ggpairs()

dat %>% 
  ggplot(aes(x=visit)) +
  geom_point(aes(y=systolic),color="red") +
  geom_point(aes(y=diastolic),color="black") +
  stat_summary(aes(y=systolic),geom="path", color="red") +
  stat_summary(aes(y=diastolic),geom="path", color="black") +
  labs(y="blood pressure") +
  facet_wrap(~race)

# dplyr verbs
# mutate() # add a column
# select() # select columns
# filter() # select rows
# and is &, or is | 

# new verbs
# group_by()
# summarize()

# will make a vector of which group you pick and a summary of an attribute of it
dat %>% 
  group_by(race) %>% 
  summarize(mean_systolic = mean(systolic))
dat %>% 
  group_by(race,sex) %>% 
  summarize(mean_systolic = mean(systolic))

# aggregate: collapsing multiple values into a single value
# summarize and arrange functions for aggregation and sorting
# reorder df by using column names
# arrange()

