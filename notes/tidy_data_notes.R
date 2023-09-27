#### tidy data rules ####
# rule 1: every variable gets its own column
# rule 2: every observation gets its own row
# rule 3: rectangular data

#### Practice ####
library(tidyverse)
# this is nice data
table1 %>% 
  ggplot(aes(x=year, y=cases, color=country)) +
  geom_path()

# in this, cases and population should be separate columns
table2
# made information into a character that looks like a ratio
table3

# use data from type to create cases and population
table2 %>% 
  pivot_wider(names_from=type, values_from=count)
# separate the rate column into cases and population
table3 %>% 
  separate(rate, into=c("cases","population")) 

# two parts, one is cases and the other is population
table4a
table4b
# method 1
a <- table4a %>% 
  pivot_longer(-country, names_to="year",values_to="cases") #-country means all the columns except country
b <- table4b %>% 
  pivot_longer(-country, names_to="year",values_to="population")
full_join(a,b)
# method 2
full_join(
  table4a %>% 
    pivot_longer(-country, names_to="year",values_to="cases"), 
  table4b %>% 
    pivot_longer(-country, names_to="year",values_to="population")
)

# has separate century and year
table5
# combine em
table5 %>% 
  mutate(date=paste0(century,year) %>% as.numeric()) %>% 
#lets you build new columns based on old ones however you want, give a new column name
  select(-century,-year) %>% 
  separate(rate, into=c("cases","population"), convert=TRUE)
  