library(tidyverse)

data <- read.csv("practice.csv")

ggplot(data, aes(x=GS.Fem.pg - GS.Male.Mb, y=lnRRlifespan,)) +
  geom_point()
