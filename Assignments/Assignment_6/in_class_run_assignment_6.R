library(tidyverse)
library(janitor)
library(gganimate)
library(skimr) #looks through a dataframe and gives you a summary

#skim(df)
# df$sample_id %>% unique() use unique to see the unique names

df <- read_csv("../../Data/BioLog_Plate_Data.csv") %>% 
  clean_names() %>% 
  pivot_longer(starts_with("hr"),
               names_to="hr",
               values_to="abs",
               names_prefix = "hr_",
               names_transform = as.numeric) %>% 
  mutate(type = case_when(sample_id == "Clear_Creek" ~ "water",
                          sample_id == "Waste_Water" ~ "water",
                          sample_id == "Soil_1" ~ "soil",
                          sample_id == "Soil_2" ~ "soil"))

df %>% 
  filter(dilution == .1) %>% 
  ggplot(aes(x=hr,y=abs,color=type))+
  geom_smooth(se=FALSE)+
  facet_wrap(~substrate)

df %>% 
  filter(substrate == "Itaconic Acid") %>% 
  group_by(dilution,sample_id,hr) %>% 
  summarize(mean_abs = mean(abs)) %>% 
  ggplot(aes(x=hr,y=mean_abs,color=sample_id)) +
  geom_path()+
  facet_wrap(~dilution)+
  theme_minimal()+
  transition_reveal(hr)


