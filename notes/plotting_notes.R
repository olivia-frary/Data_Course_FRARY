library(tidyverse)

# r graph gallery
#

iris
# give it a data frame
# map column names to various aspects of plot.
# give it geoms (things to draw)
ggplot(iris,aes(x=Petal.Length,
                y=Petal.Width,
                color=Species)) +
  geom_point(alpha=.25) +
  geom_smooth(method="lm",se=FALSE) + #defualt, loess curve
  scale_color_viridis_d() +
  theme_minimal() +
  labs(x="Petal Length",
       y="Petal Width",
       color="Species of Iris") +
  facet_wrap(~Species)


mpg
ggplot(mpg,aes(x=hwy,
               y=cty,
               color=manufacturer))+
  geom_point(alpha=.5) +
  geom_smooth(method=lm,se=FALSE) +
  facet_wrap(~trans)

# facet_wrap(~data,scales= 'free') gets rid of the N/As
