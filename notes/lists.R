

library(tidyverse)

mpg %>% names


mpg %>% 
  ggplot(aes(x=displ,y=hwy,color=factor(cyl))) +
  geom_smooth(method="lm") # visualisation of a linear regression
# statistical models just help us be less wrong
mpg$hwy %>% mean

m <- glm(data = mpg,
    formula = hwy ~ displ) # generalized linear model
# this is spitting out a list of stats jargon
# ~ means "as a function of"
 summary(m)
 # y = -3.5306x + 35.6977
 
 n <- glm(data = mpg,
          formula = hwy ~ displ + factor(cyl))
summary(n) 
n$coefficients

library(modelr)
preds <- add_predictions(mpg,n)

preds %>% 
  ggplot(aes(x=displ,color=factor(cyl))) +
  geom_point(aes(y=hwy),color='black') +
  geom_smooth(method='lm',aes(y=pred))
