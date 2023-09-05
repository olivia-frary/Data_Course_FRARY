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
list.files(path='Data',
           pattern='^b',
           recursive=TRUE)

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