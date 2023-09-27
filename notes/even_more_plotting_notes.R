library(GGally)

# gives you stats in plots for all the variables against eachother
# ** means significant
# self by self shows the distribution
GGally::ggpairs(iris)
df <- read_tsv("Data/DatasaurusDozen.tsv")

#### What to do: ####
# use your full y-axis, show all the data
# is there is an outlier, show both (ggforce) to show both

#### DO NOT ####
# Do not use 3d plots
# do not use pie charts
# no more than six colors

#library(plotly)
#ggplotly(name of plot) 

#library(kableExtra) will give you s nice table
#head(penguins) %>% 
#  kable() %>% 
#  kable_classice(lightable_options = 'hover')

library(gganimate)
iris %>% 
  mutate(blink=Sepal.Width < 3) %>% 
  ggplot(aes(x=Sepal.Length, y=Sepal.Width,color=Species)) +
  geom_point() +
  gganimate::transition_states(blink,state_length = 0.5)
