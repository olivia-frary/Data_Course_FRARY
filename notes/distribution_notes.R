#### distribution notes ####
# normal distribution
# can be explained by two properties
# mean
# standard deviation

# in science there is some true distribution out in the world, we want to know what the distribution is
# so we collect data. We will get a distribution that is probably wrong.
# we will measure again and get a different distribution

# central limit theorem
# the more samples you get the closer you'll get to the true distribution (n= infinity)

# how do you know when you've sampled enough???
# we do what is called a power analysis
# ?how many samples would I need in order to detect a change of *this* size?

# your difference still could be random error
# you will do a t-test baby - glm() with two populations

# p-value, measure of how suprised you whould be to see what you saw
# p-value is the area under the curve from the probability of getting your value.
# p-value makes the assumption that your two groups are the exact same curve. 

# glm() calculates the f-statistic for you

# pay attention to your model p-values

# lme4 package
# lmer test package - gives p-value
# stats class do frequentist stats
# the other type is bayesian stats - will spit out a distribution
#     can do tidymodels to do bayesian to look smart
library(tidyverse)

data.frame(x = rnorm(1000000, mean = 5, sd = 10)) %>% 
  ggplot(aes(x)) + 
  geom_density()

rnorm(10)

x <- c()
for(i in 1:1000){
  x[i] <- (rbinom(1,100,0.5)) # did 100 coin flips, spits out how many were heads
}

data.frame(x) %>% 
  ggplot(aes(x)) + 
  geom_density()
