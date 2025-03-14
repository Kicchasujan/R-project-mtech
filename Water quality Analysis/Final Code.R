# Load necessary libraries
library(dplyr)
library(ggplot2)
library(caret)
library(cluster)
library(arules)
library(corrplot)
library(lattice)
library(Matrix)
# Load dataset
data <- read.csv("Book2.csv")
head(data)

colSums(is.na(data))
data <- na.omit(data)
colSums(is.na(data))
head(data)

data$Source <- as.factor(data$Source)
data$Color <- as.factor(data$Color)

summary(data)
corrplot(cor(data[, sapply(data, is.numeric)], use="complete.obs"), method="circle")

ggplot(data, aes(x=pH)) + geom_histogram(binwidth=0.2, fill="blue", color="black") + theme_minimal()

ggplot(data, aes(x=pH, y=Total.Dissolved.Solids, color=Source)) + geom_point() + theme_minimal()

data_scaled <- scale(data[, sapply(data, is.numeric)]) # Normalize numeric data
kmeans_result <- kmeans(data_scaled, centers=3, nstart=25)
data$Cluster <- as.factor(kmeans_result$cluster)
ggplot(data, aes(x=pH, y=Total.Dissolved.Solids, color=Cluster)) + geom_point()


rules <- apriori(data, parameter=list(supp=0.1, conf=0.8))
inspect(head(rules))



library(rpart)
library(rpart.plot)
tree_model <- rpart(Source ~ pH + Iron + Lead + Fluoride + Copper, data=data, method="class")
rpart.plot(tree_model)
