#### Exam 1 ####
# working within the Exam_1 project
# load in needed packages
library(tidyverse)

# Task I
# Read in covid data as a dataframe
data <- read.csv("cleaned_covid_data.csv")

# Task II
# subset the data by states that begin with 'A'
A_states <- subset(data, grepl("^A", Province_State))

# Task III
# My dates were not in the date data type so I converted them
A_states$Last_Update <- as.Date(A_states$Last_Update, format="%Y-%m-%d")
# create a scatterplot of deaths over time with a loess curve and separate facets
ggplot(A_states, aes(x=Last_Update,
                     y=Deaths,
                     color=Province_State)) +
  geom_point() +
  geom_smooth(se=FALSE,color='black') +
  facet_wrap(~Province_State, scales="free")

# Task IV
# Set state names as factors
data$Province_State <- as.factor(data$Province_State)
# created and object to hold the all tha max values for each state, moving past NAs
# used two NA commands because that was the only way I still saw all the states
max_col <- aggregate(.~Province_State, data, FUN=max, na.rm=TRUE, na.action = na.pass)
# Created a new data frame and added in the wanted columns from 'max_col'
Province_State <- max_col$Province_State
Maximum_Fatality_Ratio <- max_col$Case_Fatality_Ratio
state_max_fatility_rate <- data.frame(Province_State,Maximum_Fatality_Ratio)
# ordered the data in decreasing order
state_max_fatility_rate <- state_max_fatility_rate[order(state_max_fatility_rate$Maximum_Fatality_Ratio, decreasing=TRUE),]

#peaks <- c()
# for(i in unique(df$Province_State)){
#  x <- df[df$Province_State == i,]
#  max(x$Case_Fatality_Ratio, na.rm = TRUE)
#  peaks[i] <- y
#}
#state max fatality rate <- data.frame(State = names(peaks),
#                                      Peak = peaks)

#df %>%
#  group_by(Province_State) %>%
#  summarize(Max = max(Case_Fatality_Ratio, na.rm=TRUE))
  

# Task V
# turn my fatality data into a numeric data type for graphing.
state_max_fatility_rate$Maximum_Fatality_Ratio <- as.numeric(state_max_fatility_rate$Maximum_Fatality_Ratio)
# created a plot of fatality ratios by state in decreasing order
ggplot(state_max_fatility_rate, aes(x=reorder(Province_State, -Maximum_Fatality_Ratio),
                                    y=Maximum_Fatality_Ratio)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  xlab("State") + ylab("Maximum Fatility Ratio")

# no bonus question because I am quite sick

#data %>%
#  group_by(Last_Update) %>%
#  summarize(cumulative_deaths = sum(Deaths, na.rm = TRUE))
#ggplot(aes(x=Last_Update, y=cumulative_deaths)) +
#  geom_point()

