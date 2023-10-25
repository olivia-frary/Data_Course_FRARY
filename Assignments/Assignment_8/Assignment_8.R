#### Assignment 8 ####
library(tidyverse)
library(easystats)
library(modelr)
library(MASS)
# working from within the Assignment 8 directory
# load in mushroom data set
df <- read_csv("../../Data/mushroom_growth.csv")

# plots exploring the relationships between the response and predictors
df %>% 
  ggplot(aes(x=as.factor(Light),y=GrowthRate,fill=Species)) +
  geom_violin() +
  labs(x="Light", y="Growth Rate")
df %>% 
  ggplot(aes(x=as.factor(Nitrogen),y=GrowthRate)) +
  geom_violin() +
  facet_wrap(~Nitrogen, scales="free") +
  labs(x="Nitrogen", y="Growth Rate")
df %>% 
  ggplot(aes(x=Humidity,y=GrowthRate,fill=Species)) +
  geom_violin() +
  labs(x="Humidity", y="Growth Rate")
df %>% 
  ggplot(aes(x=as.factor(Temperature),y=GrowthRate,fill=Species)) +
  geom_violin() +
  labs(x="Temperature", y="Growth Rate")
df %>% 
  ggplot(aes(x=Species,y=GrowthRate,fill=Species)) +
  geom_violin() +
  labs(x="Species", y="Growth Rate")
# relationships between the 'continuous' predictors and response, by species
df %>% 
  ggplot(aes(x=Light,y=GrowthRate,fill=Species)) +
  geom_point() +
  geom_smooth(method="lm") +
  labs(x="Light", y="Growth Rate")
df %>% 
  ggplot(aes(x=Light,y=GrowthRate,fill=Humidity)) +
  geom_point() +
  geom_smooth(method="lm") + # this one is by humidity to see if there is difference
  labs(x="Light", y="Growth Rate")
df %>% 
  ggplot(aes(x=Nitrogen,y=GrowthRate,fill=Species)) +
  geom_point() +
  geom_smooth(method="lm") +
  labs(x="Nitrogen", y="Growth Rate")
df %>% 
  ggplot(aes(x=Temperature,y=GrowthRate,fill=Species)) +
  geom_point() +
  geom_smooth(method="lm") +
  labs(x="Temperature", y="Growth Rate")

# define at least 4 models that explain "GrowthRate"
# original thoughts on making models, simple -> complicated -> stepAIC
mod1 <- glm(data=df, formula= GrowthRate ~ Species)
mod2 <- glm(data=df, formula= GrowthRate ~ Species+Light+Humidity+Nitrogen+Temperature)
mod3 <- glm(data=df, formula= GrowthRate ~ Species*Light*Humidity*Nitrogen*Temperature)
step <- stepAIC(mod3)
step$formula
mod4 <- glm(data=df, formula= step$formula)
compare_performance(mod1,mod2,mod3,mod4) %>% plot # mod4 is the best

# trying to compare different predictors to understand what to plot
df %>% names
m1 <- glm(data=df, formula=GrowthRate~Species)
m2 <- glm(data=df, formula=GrowthRate~factor(Light))
m3 <- glm(data=df, formula=GrowthRate~factor(Nitrogen))
m4 <- glm(data=df, formula=GrowthRate~Humidity)
m5 <- glm(data=df, formula=GrowthRate~factor(Temperature))
compare_performance(m1,m2,m3,m4,m5) %>% plot # light is the best independent predictor
compare_performance(m2,mod4) %>% plot # mod4 seems to cover way more bases than m2 still

# calculate the mean sq. error of each model
aov(mod1) %>% summary
aov(mod2) %>% summary
aov(mod3) %>% summary
aov(mod4) %>% summary
aov(m1) %>% summary
aov(m2) %>% summary
aov(m3) %>% summary
aov(m4) %>% summary
aov(m5) %>% summary

# alternative method found online, gets different numbers...
m2_summ <- summary(m2)
mean(m2_summ$df.residual^2)

# select the best model
compare_performance(m1,m2,m3,m4,m5,mod1,mod2,mod3,mod4) %>% plot # mod4 appears best

# add predictions based on new hypothetical values
# make a new dataframe with the predictor values we want to asses
newdf <- data.frame(Species=c("P.ostreotus","P.ostreotus","P.ostreotus","P.cornucopiae","P.cornucopiae","P.cornucopiae","P.ostreotus","P.ostreotus","P.cornucopiae"),
                    Light=c(10,20,0,20,10,0,20,10,0),
                    Nitrogen=c(20,25,45,5,10,0,30,35,40),
                    Humidity=c("Low","Low","High","Low","Low","High","Low","Low","High"),
                    Temperature=c(20,25,20,25,20,25,20,25,20))
# add some predictions for the actual values for funsies
df1 <- df %>% 
  add_predictions(mod4) 
df1 %>% dplyr::select("GrowthRate","pred")

# make predictions
pred <- predict(mod4,newdf) # predictions made with best model we had - model 4
# combine hypothetical input data with the hypothetical predictions into one data frame 
hyp_preds <- data.frame(Species=newdf$Species,
                        Light=newdf$Light,
                        Nitrogen=newdf$Nitrogen,
                        Humidity=newdf$Humidity,
                        Temperature=newdf$Temperature,
                        pred = pred)
df1$PredictionType <- "Real"
hyp_preds$PredictionType <- "Hypothetical"
fullpreds <- full_join(df,hyp_preds)
bothpreds <- full_join(df1,hyp_preds)

# plot predictions
# hypothetical predictions
fullpreds  %>% 
  ggplot(aes(x=Light,y=GrowthRate)) + # predictions plotted - GrowthRate from Light
  geom_point() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal() 
fullpreds  %>% 
  ggplot(aes(x=Nitrogen,y=GrowthRate)) + # predictions plotted - GrowthRate from Nitrogen
  geom_point() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal() 
fullpreds  %>% 
  ggplot(aes(x=Temperature,y=GrowthRate)) + # predictions plotted - GrowthRate from Temperature
  geom_point() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal() 
# violin plots to check out density
fullpreds  %>% 
  ggplot(aes(x=as.factor(Light),y=GrowthRate)) + # predictions plotted - GrowthRate from Light
  geom_violin() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal() 
fullpreds  %>% 
  ggplot(aes(x=as.factor(Nitrogen),y=GrowthRate)) + # predictions plotted - GrowthRate from Nitrogen
  geom_violin() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal() 
fullpreds  %>% 
  ggplot(aes(x=as.factor(Temperature),y=GrowthRate)) + # predictions plotted - GrowthRate from Temperature
  geom_violin() +
  geom_point(aes(y=pred),size=3,alpha=0.75,col="green") +
  theme_minimal()

# actual number predictions with top 4 models
df %>%
  gather_predictions(mod2,mod3,mod4,m2) %>% 
  ggplot(aes(x=Light,y=GrowthRate)) + # plotted with Light
  geom_point(size=3) +
  geom_point(aes(y=pred,color=model)) +
  geom_smooth(aes(y=pred,color=model)) +
  theme_minimal() 
# showing actual preds and hypothetical preds, black is the original data
ggplot(bothpreds,aes(x=Light,y=pred,color=PredictionType)) +
  geom_point(aes(y=GrowthRate),color="Black") +
  geom_point(size=2) +
  theme_minimal()
ggplot(bothpreds,aes(x=Light,y=pred,color=PredictionType)) +
  geom_point(aes(y=GrowthRate),color="Black") +
  geom_smooth(aes(y=GrowthRate),color="Black") +
  geom_point(size=2) +
  geom_smooth() +
  theme_minimal()

#### Questions ####

# Are any of your predicted response values from your best model scientifically
# meaningless? Explain.

# Model 4 tended to predict within the denser parts of the data. This could suggest
# that it predicts the data well. There weren't any predicted points that were
# wildly out of the ordinary. It is hard to see clear linear relationships in 
# some of the plots so the predictions in those might not be as reliable as 
# they don't follow a clear pattern. 


# In your plots, did you find any non-linear relationships? Do a bit of 
# research online and give a link to at least one resource explaining how to
# deal with modeling non-linear relationships in R.

# It was hard to say that any of these were good linear models. GrowthRate as
# a function of Nitrogen stands out as one that seemed particularly non linear. 

# https://rpubs.com/abbyhudak/nonlinreg
# transform data to make it linear
# fit non-linear functions to data
# fit polynomial models to data 
# you need to do your research to understand a non-linear function that would be
# appropriate to represent your data. 


# Write the code you would use to model the data found in 
# “/Data/non_linear_relationship.csv” with a linear model (there are a few ways
# of doing this)

dat <- read_csv("../../Data/non_linear_relationship.csv")

# I want to try transforming the data to fit it linearly
# It looks exponential so lets ln() it.
train_dat <- dat
train_dat$log_response <- log(dat$response)
lin_mod <- glm(data=train_dat, formula = log_response~predictor)
lin_mod %>% summary

# transformed data with linear regression line
train_dat %>% 
ggplot(aes(x=predictor,y=log_response)) +
  geom_point() +
  geom_smooth(method="lm")

# compared to the non-transformed data with a linear regression line
dat %>% 
  ggplot(aes(x=predictor,y=response)) +
  geom_point() + 
  geom_smooth(method="lm")
 
