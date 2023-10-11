library(tidyverse)
library(janitor)
library(GGally)

# import the data set and tidy it,
df <- read_csv("Utah_Religions_by_County.csv") %>% 
  clean_names() %>% 
  pivot_longer(-c("county","pop_2010","religious"),
               names_to = "religion",
               values_to = "religion_proportion") %>% 
  select(-religious) %>% 
  mutate(religion_pop = pop_2010*religion_proportion) # this isn't necessary

# use ggpairs to get an initial look at the data, county had too many levels
# and had to be removed
df %>% 
  select(-county) %>% 
  ggpairs()

####--------------------------------------------------------------------####
# "Does population of a county correlate with the proportion of any specific 
# religious group in that county?"

# lets look at the religion proportion compared to population size
df %>% 
  ggplot(aes(x=pop_2010,y=religion_proportion,color=religion)) +
  geom_smooth(method="lm",color="black", linetype=2) +
  geom_point(size=2.5, alpha=0.5) +
  facet_wrap(~religion, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5, hjust=1))
df %>% 
  ggplot(aes(x=pop_2010,y=religion_proportion,color=religion)) +
  geom_smooth(se=FALSE,color="gray", linetype=2) +
  geom_point(size=2.5, alpha=0.5) +
  facet_wrap(~religion, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5, hjust=1))
# made the y scale free to see how each religions proportion is related to 
# larger populations. When not scaled, you can't see the detail, because 
# LDS proportion is so much bigger.

# bar chart where the counties are ordered by increasing population and
# chart is faceted by religion
df %>% 
  ggplot(aes(x=reorder(county, pop_2010),y=religion_proportion,fill=religion)) +
  geom_col() +
  facet_wrap(~religion, scales="free") +
  theme(axis.text.x = element_text(angle=90,vjust=0.5, hjust=1))
# this is plotting the religion proportions in the different counties

# Larger counties don't necessarily have a higher proportion of any particular
# religious group. We can't see a correlation from any of these figures. Even
# with the linear lines, the standard error is too large. 

####--------------------------------------------------------------------####
# “Does proportion of any specific religion in a given county correlate
# with the proportion of non-religious people?”

# a bar plot that shows the proportion of religions in different counties
df %>%
  ggplot(aes(x=religion,y=religion_proportion,fill=religion)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90,vjust=0.5,hjust = 1)) +
  facet_wrap(~county)
# I tried a bunch of other subsets and plots but this was the only one that
# actually showed information comparing religions.
# It shows that the proportion of non_religious individuals in a county is
# typically higher than most religions but lower than LDS. We see exceptions
# to this in Grand County, San Juan County, and Summit county where 
# non_religious takes up a larger proportion than LDS. However, in those
# counties non_religious proportions are still 50% or less.

# lets try with a data frame that keeps non-religious separate
df2 <- read_csv("Utah_Religions_by_County.csv") %>% 
  clean_names() %>% 
  pivot_longer(-c("county","pop_2010","religious","non_religious"),
               names_to = "religion",
               values_to = "religion_proportion") %>% 
  select(-religious) %>% 
  mutate(religion_pop = pop_2010*religion_proportion) %>% 
  ggplot(aes(x=non_religious,y=religion_proportion)) +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm") +
  facet_wrap(~religion, scales="free")
df2 # run df2
# this plot was more interesting to look at. for the most part, most religions 
# in utah counties don't have a specific clear relationship with non-religious
# proportions. However, with LDS we see a pretty focused negative relationship.
# Higher non_religious proportions relate to lower LDS proportions and vice versa.
# It seems like LDS and non-religious hold most of the population in Utah counties,
# and they can trade off, though the bar chart shows that LDS is usually larger. 


