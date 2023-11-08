library(tidyverse)
library(dplyr)
library(modelr)
library(easystats)
library(GGally)
library(skimr)
library(MASS)

grad_admit <- read_csv("../../Data/GradSchool_Admissions.csv") %>% 
              mutate(admit = as.logical(admit))

glimpse(grad_admit) # admit is a binary for acceptance
ggpairs(grad_admit) # honestly not super interesting to me, but I'm bad at looking at these initial plots
skim(grad_admit) # shows a layout of the data, the percentiles and distributions

# figure of admsissions based on gpa, faceted by rank of undergrad institution
grad_admit %>% 
  ggplot(aes(x=admit, y=gpa, fill=admit)) +
  geom_violin(alpha = 0.6) +
  facet_wrap(~rank) +
  theme_minimal()

# figure of admissions based on gre, faceted by rank of undergrad institution
grad_admit %>% 
  ggplot(aes(x=admit, y=gre, fill=admit)) +
  geom_violin(alpha = 0.6) +
  facet_wrap(~rank) +
  theme_minimal()
  
# lets get into some model building bitchessss
m1 <- glm(data=grad_admit, formula=admit~gre+gpa,
          family = "binomial")

m2 <- glm(data=grad_admit, formula=admit~gre+gpa+rank,
          family = "binomial")

m3 <- glm(data=grad_admit, formula=admit~gre*gpa,
          family = "binomial")

m4 <- glm(data=grad_admit, formula=admit~gre*gpa+rank,
          family = "binomial")

m5 <- glm(data=grad_admit, formula=admit~gre*gpa*rank,
          family = "binomial")

# summaries
summary(m1)
summary(m2)
summary(m3)
summary(m4)

# get the "full" model, found stepwise with AIC
step <- stepAIC(m5)
step$formula

m6 <- glm(data=grad_admit, formula=step$formula,
          family = "binomial")

# compare the models that we have
comp <- compare_performance(m1,m2,m3,m4,m5,m6,rank=TRUE)

comp[,c("Name","Performance_Score")]


plot(comp)
compare_performance(m4,m6) # error that the models appear identical 
step$formula # looking at the model formulas side by side to see how they account for interactions differently
m4$formula
# this is interesting to see, It is hard to pick out a "best" model visually
# based on the performance scores, model 4 and model 6 are identical even though
# they have different formulas. Let's use model 4 since the formula is simpler 
# and it doesn't seem to make a difference in this comparison. 

# lets see how m4 predictions fit the data
df1 <- grad_admit
df1$pred4 <- m4$fitted.values
# i compared m2 also, m4 fit the data the best but it still kinda sucks

# gather predictions from all the models and compare them 
grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=gre,y=pred,color=model)) +
  geom_point(alpha=0.5) +
  geom_smooth(method = "lm", se=FALSE) +
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=gre,y=pred,color=model)) +
  geom_point(alpha=0.5, aes(color=admit)) +
  geom_smooth(method = "lm", se=FALSE) +
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=gpa,y=pred,color=model)) +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm",se=FALSE) +
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=gpa,y=pred)) +
  geom_point(alpha=0.5, aes(color=admit)) +
  theme_minimal() +
  scale_color_viridis_d()
grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=gre,y=pred)) +
  geom_point(alpha=0.5, aes(color=admit)) +
  theme_minimal() +
  scale_color_viridis_d()

grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=rank,y=pred)) +
  geom_point(alpha=0.5, aes(color=admit)) +
  geom_smooth(method="lm",se=FALSE) +
  facet_wrap(~admit) +
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(grad_admit,m3,type="response") %>% 
  ggplot(aes(x=gre,y=pred,color=admit)) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(grad_admit,m3,type="response") %>% 
  ggplot(aes(x=gre,y=pred,color=admit)) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(grad_admit,m3,type="response") %>% 
  ggplot(aes(x=gpa,y=pred,color=admit)) +
  geom_point(alpha=0.5) +
  geom_smooth() +
  facet_wrap(~rank) +
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(grad_admit,m3,type="response") %>% 
  ggplot(aes(x=gre,y=pred,color=factor(rank))) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  facet_wrap(~admit) +
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(grad_admit,m3,type="response") %>% 
  ggplot(aes(x=gpa,y=pred)) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  facet_wrap(~admit) +
  theme_minimal() +
  scale_color_viridis_d()

grad_admit %>% 
  gather_predictions(m1,m2,m3,m4,m5,m6,type = "response") %>% # will show probabilities
  ggplot(aes(x=admit,y=pred,fill=admit)) +
  geom_violin(alpha=0.6)+
  facet_wrap(~model) +
  theme_minimal()

add_predictions(grad_admit,m4,type="response") %>% 
  ggplot(aes(x=admit,y=pred,fill=admit)) +
  geom_violin(alpha = 0.6) +
  facet_wrap(~rank) +
  theme_minimal()
# lets focus on model 3 since it's our 'best' model, based off the AICstep,
# here is how it looks faceted by institution ranking. 

# may be a good option to go back and train your models on 80% of the data
# leave 20% to test your models on.

# lets see if training the model on 80% of the data will show a different affect
# or confirm itself. 
set.seed(123)
training_samples <- caret::createDataPartition(seq_along(grad_admit$admit),
                                               p=.8)
train_data <- grad_admit[training_samples$Resample1,]
test_data <- grad_admit[-training_samples$Resample1,] # all rows not in training_samples

m4_formula <- m4$formula

m4 <- glm(data=train_data, formula=m4_formula,
          family="binomial")

add_predictions(test_data,m4,type="response") %>% 
  ggplot(aes(x=gpa,y=pred,color=factor(rank))) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(test_data,m4,type="response") %>% 
  ggplot(aes(x=gre,y=pred,color=factor(rank))) +
  geom_point(alpha=0.5) +
  geom_smooth() + 
  theme_minimal() +
  scale_color_viridis_d()

add_predictions(test_data,m4,type="response") %>% 
  ggplot(aes(x=gre,y=pred,color=admit)) +
  geom_point(alpha=0.5) +
  geom_smooth(se=FALSE) +
  theme_minimal() +
  facet_wrap(~rank) +
  scale_color_viridis_d()

m6 %>% model_parameters()
