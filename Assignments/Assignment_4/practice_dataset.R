library(tidyverse)

data <- read.csv("Assignments/Assignment_4/fake_dance_data.csv")
data$PainScale <- as.numeric(data$PainScale)

ggplot(data, aes(x=DanceGenre, ..count..)) +
  geom_bar(aes(fill = InjuryType), position = "dodge") +
  facet_wrap(~DanceGenre, scales = "free")

