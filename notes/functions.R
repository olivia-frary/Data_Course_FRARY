my_function <- function(x){
  return(x+3)
}
second_function <- function(x=10){
  return(x+3)
}
second_function()



my_function(10)

source("./notes/clean_the_bird_data.R")

clean_the_bird_data("./Data/Bird_Measurements.csv")
head(full)
