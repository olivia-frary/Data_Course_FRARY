library(tidyverse)


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



#### LISTS ###
a <- 1:10
b <- letters
c <- c(TRUE, TRUE, FALSE)
x <- list(a,b,c)

x[[1]] # returns first list element
x[[2]] # returns second list element
x[[3]] # returns third list element
x[[1]][3] # returns 3rd thing in first list element

for(i in 1:3){
  print(x[[i]][1])
}

# PURRR / MAP
map(x,1) # this returns a list that is doing the function you requested
map_chr(x,1) # this turns it into a character vector for you, the warning is fine
map(x,class)
y <- list(a=iris,b=mtcars)
map(y,class)

# function that takes first and second columns, makes new column with product
prod_function <- 
function(x){
  if(!is.numeric(x[,1])){ # give if a true/false sequence
    # stop("Hey, ummmmm that first column isn't numeric. Try again.")
    x[,1] <- as.numeric(x[,1])
  } 
  new_col <- x[,1] * x[,2]
  x["products"] <- new_col
  return(x)
}

y$a$Sepal.Length <- as.character(y$a$Sepal.Length)

map(y,prod_function) # the function will be applied to every element of the list 
# lapply(iris,as.character) # example of applying to every list (column)






