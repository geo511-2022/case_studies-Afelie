
library(dplyr)
library(ggplot2)
data(iris)
mean(iris$Petal.Length)

hist(iris$Petal.Length)
Plot1 <- hist(iris$Petal.Length)



Plot2 <- ggplot(iris, aes(x=Petal.Length)) + geom_histogram(fill="#00FF11") + ggtitle("Count of Petal Length")
Plot2

