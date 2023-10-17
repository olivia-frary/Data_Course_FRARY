library(tidyverse)
library(palmerpenguins)
library(easystats)

penguins %>% 
  ggplot(aes(y=bill_depth_mm,x=bill_length_mm)) +
  geom_point() +
  geom_smooth(method='lm')

head(penguins)

# make linear regression of this plot
m1 <- 
glm(data = penguins,
    formula =  bill_depth_mm ~ bill_length_mm)
# according to this model, the average bill depth is 20.88547
# -0.08502 is the slope (m)

# we always visualize first and then we model

# analysis of variance
aov(data = penguins,
    formula =  bill_depth_mm ~ bill_length_mm) %>% 
  summary()
# tells you degrees of freedom, sum of squares, mean fo squares
# this is an anova table. Pr(>F) is the p-value, this only tells you 
# if your data is significant, if you chose a good variable comparison.

penguins %>% 
  ggplot(aes(y=bill_depth_mm,x=bill_length_mm,color=species)) +
  geom_point() +
  geom_smooth(method='lm',aes(linetype=sex)) +
  facet_wrap(~island)
# this is showing simpson's paradox. Now that they're separated, the
# opposite trend shows now.
# just adding, this takes into account the different species.
m2 <- 
glm(data = penguins,
    formula =  bill_depth_mm ~ bill_length_mm + species)
# the table is more confusing now. The intercept is 10.6
# this picks the default categorical variables based on the alphabet,
# adele became the intercept species. The other estimates tell you what 
# to subtract from the default
# here, slope is the same for all the species

# introducing the interaction term between bill length and species - *
m3 <- 
glm(data = penguins,
    formula =  bill_depth_mm ~ bill_length_mm * species)
# here the slope can change based on the species
# "tell me the effect of species AND the slope"

# aic is telling you which is capturing reality the best. 
m1$aic
m2$aic
m2$aic

m4 <- 
  glm(data=penguins,
      formula=bill_depth_mm ~ bill_length_mm * species + sex + island)
# what would a plot of this look like?
# same as before but facet_wrap on sex. or geom_smooth could have a
# aes(linetype=sex)

# from easystats
compare_performance(m1,m2,m3,m4) %>% plot
# R2 tells you how much variance there are to the lines. Tells you the percent
# improvement with your models
# piping to plot shows you the area to compare which is better, larger area
# does better. These show that model 2 is our best model. Our goal with a 
# model is simplicity ( and generalized). It won't be perfect, but it needs
# to be helpful.

formula(m4)
x <- 
data.frame(bill_length_mm = c(5000,100),
           species = c("Chinstrap","Chinstrap"),
           sex = c("male","male"),
           island = c("Dream","Dream"))
# we're gonna go with model 4, lets do some predicting
predict(m4,x) # it needs all the variables exactly to do a prediction


mpg %>% 
  ggplot(aes(x=(displ),y=hwy)) +
  geom_point() +
  geom_smooth(method='lm',formula = y ~ log(x))
# here the model lied to us, if you know more about cars, you can see the
# error in model. The bigger the v8 engine, you do not get better gas mileage
y <- data.frame(displ=500)
m5 <- glm(data=mpg, formula=hwy~displ)
predict(m5,y) # thermodynamics says this is not possible
# it is important to not predict outside of the data you've seen.
a <- data.frame(displ=4.5)
predict(m5,a)
# transform the data
m6 <- glm(data=mpg, formula=hwy~log(displ))
predict(m5,a)


# new built in 
Titanic %>%  as.data.frame()
# so far we've been predicting continuous variable, what about categorical
# logistice regression -> outcome is T/F
df <- read_csv("./Data/GradSchool_Admissions.csv")
df <- 
  df %>% 
  mutate(admit = as.logical(admit))
# logistic -> family = 'binomial'
m6 <- glm(data = df,
    formula = admit~gre+gpa+rank,
    family = "binomial")
m6 # these are log odds, we want percentages

library(modelr)
add_predictions(df,m6,type="response") %>% 
  # don't forget type, it's what gives us percentages !!!!!
  ggplot(aes(x=gpa,y=pred,color=factor(rank))) +
  geom_smooth()

  