clean_the_bird_data <- 
function(x){
  library(tidyverse)
  library(janitor)
  library(skimr)
  df <- read_csv(x) %>% 
    clean_names
  
  mass <- 
  df %>% 
    select(-ends_with("_n")) %>% 
    select(-ends_with(c("_wing","_tail","_tarsus","_bill")))
  
  wing <- 
    df %>% 
    select(-ends_with("_n")) %>% 
    select(-ends_with(c("m_mass","f_mass","unsexed_mass","_tail","_tarsus","_bill")))
  
  tail <- 
    df %>% 
    select(-ends_with("_n")) %>% 
    select(-ends_with(c("m_mass","f_mass","unsexed_mass","_wing","_tarsus","_bill")))
  
  bill <- 
    df %>% 
    select(-ends_with("_n")) %>% 
    select(-ends_with(c("m_mass","f_mass","unsexed_mass","_wing","_tarsus","_tail")))
  
  tarsus <- 
    df %>% 
    select(-ends_with("_n")) %>% 
    select(-ends_with(c("m_mass","f_mass","unsexed_mass","_wing","_bill","_tail")))
  
  mass <- 
  mass %>% 
    pivot_longer(c(m_mass, f_mass, unsexed_mass),
                 names_to="sex",
                 values_to="mass") %>% 
    mutate(sex = sex %>% str_remove("_mass"))
  
  wing <- 
    wing %>% 
    pivot_longer(c(m_wing, f_wing, unsexed_wing),
                 names_to="sex",
                 values_to="wing") %>% 
    mutate(sex = sex %>% str_remove("_wing"))
  
  tail <- 
    tail %>% 
    pivot_longer(c(m_tail, f_tail, unsexed_tail),
                 names_to="sex",
                 values_to="tail") %>% 
    mutate(sex = sex %>% str_remove("_tail"))
  
  bill <- 
    bill %>% 
    pivot_longer(c(m_bill, f_bill, unsexed_bill),
                 names_to="sex",
                 values_to="bill") %>% 
    mutate(sex = sex %>% str_remove("_bill"))
  
  tarsus <- 
    tarsus %>% 
    pivot_longer(c(m_tarsus, f_tarsus, unsexed_tarsus),
                 names_to="sex",
                 values_to="tarsus") %>% 
    mutate(sex = sex %>% str_remove("_tarsus"))
  
  full <- 
  bill %>% 
    full_join(mass) %>% 
    full_join(tail) %>% 
    full_join(tarsus) %>% 
    full_join(wing)
  
  return(full)
}

#saveRDS(full, "./Data/cleaned_bird_data.rds")
df <- read_csv("./Data/Bird_Measurements.csv")

