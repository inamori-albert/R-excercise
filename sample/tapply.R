library(data.table)

data <- fread('len_sp.txt', header = TRUE)

len.means <- tapply(data$len, listdata$sp, mean)
len.means

names(len.means)
len.means[1]
