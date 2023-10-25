#### Assignment 8 Example ####
library(modelr)
library(easystats)
library(broom)
library(tidyverse)
library(fitdistrplus)

data("mtcars")
glimpse(mtcars)
# here, the dependent variable is mpg, it is what we want to know

# model 1
mod1 = lm(mpg ~ disp, data = mtcars)
summary(mod1)
# call is the model you ran
# residuals are measures of how well your data fit the model
# Coefficients are the slode and intercept of the best-fit line
# visual of the model - geom smooth lm will do same thing as our model did
ggplot(mtcars, aes(x=disp,y=mpg)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_minimal()

# model 2
mod2 = lm(mpg ~ qsec, data = mtcars) # model that incorporates speed
ggplot(mtcars, aes(x=disp,y=qsec)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_minimal()
# the scatter around the line implies that the second model is poorer than the first
# let's explicitly measure the scatter using the mean-squared-error
# (the smaller the better)
mean(mod1$residuals^2) # this one is smaller, so it's better
mean(mod2$residuals^2)

# make predictions using best model (model 1)
df <- mtcars %>% 
  add_predictions(mod1) 
df %>% dplyr::select("mpg","pred")

# make a prediction based on hypothetical independent values
# Make a new dataframe with the predictor values we want to assess
# mod1 only has "disp" as a predictor so that's what we want to add here
newdf = data.frame(disp = c(500,600,700,800,900)) # anything specified in the model needs to be here with exact matching column names

# making predictions
pred = predict(mod1, newdata = newdf)

# combining hypothetical input data with hypothetical predictions into one new data frame
hyp_preds <- data.frame(disp = newdf$disp,
                        pred = pred)

# Add new column showing whether a data point is real or hypothetical
df$PredictionType <- "Real"
hyp_preds$PredictionType <- "Hypothetical"

# joining our real data and hypothetical data (with model predictions)
fullpreds <- full_join(df,hyp_preds)

# plot those predictions on our original graph
ggplot(fullpreds,aes(x=disp,y=pred,color=PredictionType)) +
  geom_point() +
  geom_point(aes(y=mpg),color="Black") +
  theme_minimal()
# some of the points appear to be negative which is not possible....

# compare predictions from several models
# Define a 3rd model
mod3 <- glm(data=mtcars,
            formula = mpg ~ hp + disp + factor(am) + qsec)

# put all models into a list
mods <- list(mod1=mod1,mod2=mod2,mod3=mod3)
# apply "performance" function on all in the list and combine 
map(mods,performance) %>% reduce(full_join)

# gather residuals from all 3 models
mtcars %>% 
  gather_residuals(mod1,mod2,mod3) %>% 
  ggplot(aes(x=model,y=resid,fill=model)) +
  geom_boxplot(alpha=.5) +
  geom_point() + 
  theme_minimal()

mtcars %>% 
  gather_predictions(mod1,mod2,mod3) %>% 
  ggplot(aes(x=disp,y=mpg)) +
  geom_point(size=3) +
  geom_point(aes(y=pred,color=model)) +
  geom_smooth(aes(y=pred,color=model)) +
  theme_minimal() +
  annotate("text",x=250,y=32,label=mod1$call) +
  annotate("text",x=250,y=30,label=mod2$call) +
  annotate("text",x=250,y=28,label=mod3$call)

# put model into interpretable english
report(mod3)
