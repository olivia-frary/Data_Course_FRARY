library(tidyverse)
library(janitor)
library(readxl)

path <- "./Data/Messy_bp.xlsx"
# the data starts lower so we're not going to see column names
# data starts on A4 and ends on M24
# range lets you fix what is shown
df <- read_xlsx(path, range = "A4:M24") %>% clean_names()

# this can be used later to get the names of the visits
# visits <- read_xlsx(path, skip = 2,n_max = 0) %>% names()

# we want to pivot all the blood pressures together
# df <- 
# df %>% pivot_longer(starts_with("bp_"), values_to =) %>% 
#   mutate(visit = case_when(name == "bp_8" ~ 1,
#                            name == "bp_10" ~ 2,
#                            name == "bp_12" ~ 3)) %>% 
#   pivot_longer(starts_with("hr_"),
#                names_to = "visit2",
#                values_to = "heart_rate")

# make a data frame with just the bp values
bp <- 
df %>%
  select(-starts_with("hr_")) %>% # for picking columns
# keeping everything except the heart rate ones
  pivot_longer(starts_with("bp_"), values_to ="bp") %>%
  mutate(visit = case_when(name == "bp_8" ~ 1,
                           name == "bp_10" ~ 2,
                           name == "bp_12" ~ 3)) %>% 
  select(-name) %>% 
  separate(bp, into = c("systolic","diastolic"), convert = TRUE)

# make data frame with just the hr values
hr <- 
df %>%
  select(-starts_with("bp_")) %>% # for picking columns
  # keeping everything except the heart rate ones
  pivot_longer(starts_with("hr_"), values_to ="hr") %>%
  mutate(visit = case_when(name == "hr_9" ~ 1,
                           name == "hr_11" ~ 2,
                           name == "hr_13" ~ 3)) %>% 
  select(-name)

# now join the two data frames
dat <- 
full_join(bp,hr)

# add a date data type column *referene posix ct -> y-m-d
dat <- 
dat %>% 
  mutate(birthdate = paste(year_birth,
                           month_of_birth,
                           day_birth,
                           sep = "-") %>%
           as.POSIXct())
dat <- 
dat %>% 
  mutate(race = case_when(race == "WHITE" ~ "White",
                          race == "Caucasian" ~ "White",
                          TRUE ~ race))

dat$race

saveRDS(dat,"./notes/cleaned_bp.rds")
