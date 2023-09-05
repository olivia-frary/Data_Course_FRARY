#### Assignment 2 ####

# list csv files in an object
csv_files <- list.files(path='./Data',
                        pattern='.csv')
length(csv_files) # finds length of object

# remember to be PRECISE, i.e. 'data' should be capitalized
# df stands for data frame, it is common use
df <- read.csv('./Data/wingspan_vs_mass.csv') 
head(df,n=5) # enter number as n=5 to be clean and precise

# ^ means use the first letter, ^b - is the first letter 'b'?
list.files(path='./Data',
           pattern='^b',
           recursive=TRUE)

