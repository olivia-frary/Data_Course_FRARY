# load in required libraries
library(tidyverse)
library(janitor)
library(broom)

#### load in and clean the data ####
df <- read_csv("FacultySalaries_1995.csv") %>% 
  clean_names()

# separate the data frame out to do the pivot longers
salary <- 
  df %>% pivot_longer(ends_with("_salary"),
                      names_to = "rank",
                      values_to = "avg_salary",
                      names_pattern = "avg_(.*)_prof_salary") %>% 
  select(c("fed_id","univ_name","state","tier","rank","avg_salary"))

comp <- 
  df %>% pivot_longer(ends_with("_comp"),
                      names_to = "rank",
                      values_to = "avg_comp",
                      names_pattern = "avg_(.*)_prof_comp") %>% 
  select(c("fed_id","univ_name","state","tier","rank","avg_comp"))

number <- 
  df %>% pivot_longer(ends_with("_profs"),
                      names_to = "rank",
                      values_to = "num",
                      names_pattern = "num_(.*)_prof") %>% 
  select(c("fed_id","univ_name","state","tier","rank","num"))

# join the data frames
d1 <- full_join(salary,comp)
df <- full_join(d1,number)

#### plot the data ####
df[df$tier != "VIIB",] %>% # tier VIIB only has three observations and is pointless to plot here
  ggplot(aes(x=rank,y=avg_salary, fill=rank)) +
  geom_boxplot() +
  facet_wrap(~tier) +
  labs(x="Rank", y="Salary") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust=1))

        
#### Build an ANOVA model ####
mod <- aov(avg_salary ~ state + tier + rank, data = df)
summary(mod)

#### get second data set ####
d1 <- read_csv("Juniper_Oils.csv") %>% 
  pivot_longer(cols=c("alpha-pinene","para-cymene","alpha-terpineol","cedr-9-ene",
                      "alpha-cedrene","beta-cedrene","cis-thujopsene","alpha-himachalene",
                      "beta-chamigrene","cuparene","compound 1","alpha-chamigrene","widdrol",
                      "cedrol","beta-acorenol","alpha-acorenol","gamma-eudesmol","beta-eudesmol",
                      "alpha-eudesmol","cedr-8-en-13-ol","cedr-8-en-15-ol","compound 2","thujopsenal"),
               names_to="ChemicalID",
               values_to="Concentration")

d1 %>% 
  ggplot(aes(x=YearsSinceBurn, y=Concentration)) +
  geom_smooth()+
  facet_wrap(~ChemicalID, scale="free") + 
  theme_minimal()


#### make a general model ####
mod2 <- glm(Concentration ~ ChemicalID*YearsSinceBurn, data = d1)
mod2 %>% summary

d2 <- tidy(mod2)
d2$term <- sub("^ChemicalID", "", d2$term)
d2[d2$p.value < 0.05,]
