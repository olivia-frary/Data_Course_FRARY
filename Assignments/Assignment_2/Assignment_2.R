#### Assignment 2 ####

# list csv files from data directory in object csv_files
csv_files <-  list.files(path="Data",
                         pattern = ".csv")
# the length function tells you how many things are in your object
length(csv_files)
# df is common to use, it stands for dataframe
df <- read.csv("./Data/wingspan_vs_mass.csv")
head(df,n=5)
# ^ means starts with
list.files(path="Data",
           pattern="^b",
           recursive=TRUE)
### DONT FORGET TO ADD COMMIT PUSH YOUR ASSIGNMENT
