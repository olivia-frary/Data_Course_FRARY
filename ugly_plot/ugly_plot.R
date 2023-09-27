library(tidyverse)
library(ggimage)
library(png)


pacman::p_load(jpeg, png, ggplot2, grid, neuropsychology)
image <- jpeg::readJPEG("ugly_plot/zahn_n_dog.jpg")

ggplot(iris, aes(x=Petal.Length, y=Sepal.Length)) + 
  annotation_custom(rasterGrob(image, 
                               width = unit(1,"npc"), 
                               height = unit(1,"npc")), 
                    -Inf, Inf, -Inf, Inf) +
  geom_point() + 
  geom_image(aes(image="ugly_plot/dogggg.png")) + 
  geom_smooth(color="red") +
  facet_wrap(~Species) +
  labs(x="GOOD BOIs", y="puppers") +
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

ggsave("ugly_plot/ugly_plot.png")
