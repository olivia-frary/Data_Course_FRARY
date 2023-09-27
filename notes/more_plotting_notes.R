library(tidyverse)
library(palmerpenguins)
library(ggimage)

# SHORTCUT %>% = ctrl, shift, 'm'

penguins %>% names

penguins %>% dim()



p <- penguins %>% 
  na.omit %>%
  ggplot(aes(x=species, y=bill_length_mm, fill=species)) +
  geom_violin() +
  geom_point(alpha=0.25, shape = 5) +
  facet_wrap(~sex, scales="free")

# + geom_image(aes(image="image.pthwy"))
  
p +
  theme(axis.title.x = element_text(face = 'bold',
                                    color = "hotpink",
                                    size = 16,
                                    hjust = 0,
                                    vjust = 0,
                                    angle=30),
        legend.text = element_text(size = 30),
        legend.title = element_text(color = "green",
                                    angle = -45,
                                    size = 5),
        strip.background = element_rect(fill = "green"),
        strip.text = element_text(color = "yellow", face = "bold", vjust = 6, hjust = 1),
        panel.grid.major = element_line(linewidth = 10, color = "yellow"),
        panel.background = element_rect(fill = "blue"),
        )




rglimpse(penguins)
penguins %>% glimpse()
1:10 %>% max()
max(c(1,2,3,4,5))

c(1,2,3,4,5) %>% max()

# the pipe makes the letters the first argument, so this doesn't work. Pipes work with everything in the tidyverse
letters %>% grep("e")
grep()
