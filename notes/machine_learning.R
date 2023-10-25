### machine learning ####
# random forest
  # bootstrap aggregating, sampling from our dataset and splitting into bins
  # randomly decides cutoffs for splitting the data
  # reality: this would be a shitty way to make predictions
  # at the end the decision trees get together and vote on what's most important
  # randomly dividing data up, running a logistic regression, and deciding at end

library(ranger)
?ranger() # for high dimensional data. Lots of columns and rows
r_mod <- ranger(Species ~ ., data = iris) # prediction species on everything else

  # classification is referring to Species names
  # based on the data I give, what species do I have?
  # downfall - there is no formula out at the end, we don't know what tree was used
  # all this can do is make predictions, it won't tell you HOW it made the predictions

pred <- predict(r_mod,iris)
data.frame(iris$Species,pred$predictions) # it did a great job, but it can't tell you how
