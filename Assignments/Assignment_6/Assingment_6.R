#### Assignment 6 ####
# Working from Assignment_6 project within the Assignment 6 folder
library(tidyverse)
library(janitor)
library(gganimate)

# this data set is about the ability of various environmental
# samples to utilize different carbon sources.
dat <- read_csv("../../Data/BioLog_Plate_Data.csv") %>% 
  clean_names()
# there is data from 4 environmental samples (two soil and two water),
# absorbance values at different hours, and dif dilutions.

# head(dat)

# task 1
# clean data into tidy (long) form.
dat <- 
dat %>% 
  pivot_longer(starts_with("hr"),
                     names_to="hr",
                     values_to="abs",
                     names_prefix = "hr_",
                     names_transform = as.numeric)

# task 2
# create a new columns specifying whether a sample is from soil or water.
# the first column holds the info about weather it's water or soil.
# there is Clear_Creek, Waste_Water, Soil_1, Soil_2
dat <- 
dat %>% 
  mutate(type = case_when(sample_id == "Clear_Creek" ~ "water",
                          sample_id == "Waste_Water" ~ "water",
                          sample_id == "Soil_1" ~ "soil",
                          sample_id == "Soil_2" ~ "soil"))

# task 3
# generate a plot that matches assignment one.
dat_dilute <- dat[dat$dilution==0.1,] %>% 
    ggplot(aes(x=hr,y=abs,color=type)) + 
      geom_smooth(se=FALSE) +
      facet_wrap(~substrate)
# this plot is throwing 50 errors, I need to ask why. The loess is mad.
# warnings()
# add the theme to the plot
dat_dilute + 
  theme_minimal() +
  labs(x="Time",
       y="Absorbance",
       color="Type")

# task 4
# generate an animated plot that matches assignment one.
# create a vector that has the mean abs by hr, id, dilution, substrate
p1 <- aggregate(abs ~ hr+sample_id+dilution+substrate, data=dat, FUN=mean)
# new data frame with only the info for Itaconic Acid and pipe into plot
p2 <- p1[p1$substrate == "Itaconic Acid",] %>% 
  ggplot(aes(x=hr,y=abs,color=sample_id)) +
    geom_line() +
    facet_wrap(~dilution) +
    theme_minimal() +
    labs(x="Time",
         y="Absorbance",
         color="Sample ID") +
    gganimate::transition_reveal(hr)
p2





