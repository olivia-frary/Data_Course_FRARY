library(tidyverse)
library(janitor)
library(easystats)
library(modelr)

# working out of Exam_2 folder

theme_set(theme_bw()) # set theme for plots

# task 1 and task 2
# read in data and get it into tidy format
df <- read_csv("unicef-u5mr.csv") %>% 
  janitor::clean_names() %>% # code kept throwing a fit if I didn't use janitor::
  pivot_longer(starts_with("u5mr_"),
               names_to = "year",
               values_to = "u5mr",
               names_prefix = "u5mr_",
               names_transform = as.numeric)

# task 3
# plot each country's U5MR over time
df %>% 
  ggplot(aes(x=year,y=u5mr,fill=country_name)) +
  geom_line(linewidth=0.75) +
  facet_wrap(~continent) +
  labs(y="U5MR",x="Year")

# task 4
ggsave("FRARY_Plot_1.png") # saved in Exam_2 folder

# task 5
# create plot that shows the mean U5MR for all the countries in a continent
# made a dummy data frame that gets the continent, year, and mean U5MR data
df1 <- 
df %>% 
  group_by(continent,year) %>% 
  summarize(mean_u5mr = mean(u5mr,na.rm=TRUE))
# create another data frame for plotting that adds the mean data to the original
# data frame
df2 <- full_join(df,df1)
df2 %>% # plotting the new data frame that has mean data
  ggplot(aes(x=year,y=mean_u5mr,color=continent)) +
  geom_line(linewidth=1.2) +
  labs(y="Mean U5MR",x="Year",color="Continent")

# task 6
ggsave("FRARY_Plot_2.png") # saved in Exam_2 folder

# task 7
# create three models of U5MR
# U5MR, accounting for year
mod1 <- glm(data = df,
    formula =  u5mr ~ year) 
# U5MR, accounting for year and continent
mod2 <- glm(data = df,
    formula =  u5mr ~ year + continent)
# U5MR, accounting for year and continent interaction
mod3 <- glm(data = df,
    formula =  u5mr ~ year * continent)

# task 8
# Compare the three models with respect to their performance
compare_performance(mod1,mod2,mod3) %>% plot
# From the figure, 'mod3' appears to be the best. It has better AIC, AICc, and BIC.
# This shows that there is less prediction error and less information lost in 'mod3'.

# task 9
# Plot the three models' predictions
# data frame with models and predictions added on
df_mods <- gather_predictions(df,mod1,mod2,mod3)
df_mods %>% # plotting the models side by side
  ggplot(aes(x=year,y=pred,color=continent)) +
  geom_line(linewidth=1.2) +
  facet_wrap(~model) +
  labs(y="Prediction U5MR",x="Year",color="Continent")

# BONUS task 10
# dummy data frame ot hold prediction parameters in
x <- data.frame(year=2020,
             country_name="Ecuador",
             continent="Americas")
predict(mod3,x) # prediction from x against model 3
# the real value for Ecuador was 13 deaths


