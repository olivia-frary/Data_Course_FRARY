#### Assignment 2 ####

# Task 4
# list csv files from data directory in object csv_files
csv_files <-  list.files(path = "Data",
                         pattern = ".csv",
                         full.names = TRUE)
# Task 5
# find length of your csv files list
length(csv_files)

# Task 6
# reads the csv file into an object names df
df <- read.csv("./Data/wingspan_vs_mass.csv")

# Task 7
# prints the first 5 lines of the df object
head(df,n=5)

# Task 8
# list files in data directory that start with 'b'
bfiles <- list.files(path = "Data",
           pattern = "^b",
           recursive = TRUE,
           full.names = TRUE)

# Task 9
# for loop that prints the first line in all the 'b' files
for(i in bfiles){
  print(readLines(i,n=1))
}

# Task 10
# print the first line of all csv files
for(i in csv_files){
  print(readLines(i,n=1))
}

