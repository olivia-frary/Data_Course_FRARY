#### shortcuts ####
# alt - = <-
# ctrl enter = runs line
# ctrl alt b = runs lines before cursor

#### for loop example ####
#using a for loop, code is inside the curly bracket
x <- 1:10
for(i in x){
  print(i*2)
}



#### Assignment 2 ####

# list csv files in an object
csv_files <- list.files(path='Data',
                        pattern='.csv')
length(csv_files) # finds length of object

# remember to be PRECISE, i.e. 'data' should be capitalized
# df stands for data frame, it is common use
df <- read.csv('./Data/wingspan_vs_mass.csv') 
head(df,n=5) # enter number as n=5 to be clean and precise

# ^ means use the first letter, ^b - is the first letter 'b'?
bfiles <- list.files(path='Data',
           pattern='^b',
           recursive=TRUE,
           full.names = TRUE)

# connection is like a file path, remember to do n= to be precise
readLines("Data/data-shell/creatures/basilisk.dat",
          n=1)
readLines("Data/data-shell/data/pdb/benzaldehyde.pdb",
          n=1)
readLines("Data/Messy_Take2/b_df.csv",
          n=1)
# now do this in a single line of code :)

# using a for loop, code is inside the curly bracket
# the 'i' iterates through items in bfiles
for(i in bfiles){
  print(readLines(i,n=1))
}

#one option
for(i in list.files(path = "Data",
                    pattern = ".csv",
                    full.names = TRUE)){
  print(readLines(i,n=1))
}



#### messing with iris - new column####
# load in iris and show the first row
iris[1,]
# view all petal width values
iris$Petal.Width
mean(iris$Petal.Width)
summary(iris$Petal.Width)
names(iris) # gives column names

iris$Petal.Length*iris$Petal.Width
iris$Petal.Area <- iris$Petal.Length*iris$Petal.Width # create a new column and fill it with areas

# gives summaries of each column, i = a column name each time through 
for(i in names(iris)){
  x <- iris[,i]
  print(summary(x))
}

#### Week 2 Practice ####
vector1 <- list.files(path = "Data/data-shell/names",
                      pattern = ".csv",
                      recursive = TRUE,
                      full.names = TRUE)
class(vector1)
#### Vector Practice Week 3 ####
# Exercise 1 
x <- c(4,6,5,7,10,9,4,15)
x < 7 # the answer is 'e'

# Exercise 2
p <- c(3,5,6,8)
q <- c(3,3,3)
p+q # I got 'e' with a warning on top

# Exercise 3
a = c(1,3,4,7,10,0)
b = c(1,2)
a+b # answer: 2 5 5 9 11 2

# Exercise 4
z <- 0:9
digits <- as.character(z)
as.integer(digits) # answer is 'b'
# if it can be an integer it will do it

# Exercise 5
x <- c(1,2,3,4)
(x+2)[(!is.na(x)) & x > 0] -> k
# i think this is a TRUE Boolean that then makes an
# object 'k' that adds 2 to 'x'


#### Factors Practice Week 3 ####
library(tidyverse)
library(gapminder)
data("gapminder")
df = gapminder
head(gapminder)

# the continent variable is a factor
levels(df$continent)
# how to add a factor to the list
levels(df$continent) <- c(levels(df$continent), "Antarctica")
levels(df$continent) <- c(levels(df$continent),
                          "North America",
                          "South America",
                          "Central America")
# use the table function to check the occurrences of each factor
table(df$continent)
# this is where I am stuck, I need to research how to add data
# to a new level
south <- c("Argentina","Bolivia","Brazil","Chile","Colombia","Ecuador","Paraguay",
           "Peru","Uruguay","Venezuela")

# right now this isn't working, try having it print true to see where the issue is
for (i in df$country)
  if (df[i,1] %in% south){
   rbind(df, df[,]) 
  }

#### Characters Practice Week 3 ####
# exercise 1
library(tidyverse)
vector <- ("Good morning! ")
nchar(vector)
# exercise 2
x <- c("Open", "Sesame ")
y <- c("You", "Suck.")
nchar(x) # creates a vector with the two lengths
nchar(c(x,y))

#### Sequences Practice Week 3 ####
# exercise 1
seq(1,10,by=2)
seq(1,10,by=3)
#exercise 2
seq(9,45,9)
#exercise 3
seq(1,12,length.out=5)
seq(1,10,length.out=3) # breaks it into 3 pieces and rounds
# exercise 4
x = 1:5
rep(x,2)
rep(x,2,each=2)
rep(x,each=4)
# in class challenge
seq(1,1000,2)
rep(seq(1,1000,2),100)


#### Indexing Practice Week 3 ####
# exercise 1
x = c("ss","aa","ff","kk","bb")
x[1]
x[c(1,3)]
# exercise 2
d = data.frame(Name = c("Betty","Bob","Susan"),
               Age = seq(20,30,length.out=3),
               Height_cm = c(490,22,0))
d[c("Name","Age")] # shows the whole columns of name and age
d[c("Age","Name","Height_cm")][1,]
# exercise 3
d$Name
d$Age[2]
# exercise 4
d$Age > 20
d[d$Age > 20,] # only returns rows where age > 20


#### Missing Values Practice Week 3 ####
# exercise 1
X = c(NA,3,14,NA,33,17,NA,41)
is.na(X)
X[!is.na(X)] # returns the values that are NOT na



#### Loops Practice Week 3 ####
# exercise 1
for(i in 1:3){
  x <- paste0("Number ",i)
  print(x)
}

planets <- c("Mercury","Venus","Earth","Mars",
             "Jupiter","Saturn","Uranus","Neptune")
n <- 1
newVector <- c()
for(i in planets){
  newVector[n] <- paste0(i,i)
  n=n+1
}
newVector
?paste0

for(i in 1:7){
  print(i^3)
}

# exercise 2
for(i in ncol(iris)){
  x <- c(iris[1,1])
}
