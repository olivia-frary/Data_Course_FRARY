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

#### thursday notes ####
# cleaning excel data from class
# "~/Downloads/popquize data.xlsx"
# "~/Downloads/organized dataset.xlsx"
library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)

# read data into r and clean it. 
# if you need to make a dataset that has multiple columns for one variable
# you need to pivot_longer()
# fix names (col 1)
names(df1)
clean_names(df1)
df1 <- read_xlsx("popquiz data.xlsx") %>% 
  clean_names() # another method to make names data friendly
names(df1)[1] <- "site" # returns the first column name, changes it to site
# change the numbers
# change weird num into a date, must know OS and Excel version used
dates <- janitor::excel_numeric_to_date(as.numeric(df1$site[1:3]))
# pull the month name abbreviation from dates
pt_1 <- lubridate::month(dates, label=TRUE, abbr=TRUE) %>% 
  str_to_upper()
# pull day numeric from dates
pt_2 <- lubridate::day(dates)
# pasted em together with '-' as the separator
final <- paste(pt_1,pt_2,sep="-")
# overwrite numbers with these new strings
df1$site[1:3] <- final
# separate column 1 into location and site and pivot the weeks longer. 
df1 <- 
df1 %>% 
  separate(site, into=c("location","site")) %>% 
  pivot_longer(starts_with("week"),
               names_to = "week",
               values_to = "rel_abund",
               names_prefix = "week_",
               names_transform = as.numeric)


df2 <- read_xlsx("organized dataset.xlsx") %>% 
  clean_names()
df2$site <- 
df2$site %>% 
  str_replace(" Pool","Pool")
df2 <- 
df2 %>% 
  separate(site, into=c("location","site")) %>% 
  pivot_longer(starts_with("week"),
               names_to = "week",
               values_to = "rel_abund",
               names_prefix = "week_",
               names_transform = as.numeric)

df2 %>% 
  mutate(location = case_when(location == "SewagePool" ~ "SEP",
                              location == "Hatchery" ~ "HAT"))
?mutate()
?case_when()

