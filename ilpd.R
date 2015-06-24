# set seed for reproducibility
set.seed(100)

# libraries
library(caret)

#set working directory
setwd("/Users/neel/Documents/Columbia/Kaggle/indian-liver-pd")

# read data and set headers
data <- read.csv("ilpd.csv", header = FALSE)
names(data) <- c("age", "sex", "TB", "DB", "AAP", "SGPT", 
                 "SGOT", "TP", "ALB", "AG", "Label")

# seperate labels from data
features <- dim(data)[2]
labels <- data[, features] - 1
data <- data[,1:features - 1]

# convert to numeric 
data$sex <- as.numeric(data$sex)
data[is.na(data)] <- 0

# normalize data before computing correlation coeffecient
# done by subtrating min from all data in a column and then dividing 
# by max
data.n <- apply(data, 2, function(x)(x-min(x))/(max(x)-min(x)))

# get a correlation matrix for elementary feature selection and
# remove highly correlated fields
thres <- 0.75
corr.m <- cor(data.n)
highly.corr <- findCorrelation(corr.m, cutoff = thres)
data.clean <- data.n[,-highly.corr]

# split clean data into test and train
train.ind <- createDataPartition(labels, list = FALSE, times = 1)
train.data <- data.clean[train.ind,]
test.data <- data.clean[-train.ind,]
train.label <- labels[train.ind]
test.label <- labels[-train.ind]

# merge data frames
train <- data.frame(cbind(train.data, train.label))
test <- data.frame(test.data)

# fit a logistic regression model 
lr <- glm(train.label ~ age + sex + TB + AAP + SGPT + TP + AG, 
          family = binomial, data = train)

# test model
pred.labels <- predict(lr, newdata = test, type = "response")
pred.labels[pred.labels < 0.5] = 0
pred.labels[pred.labels >= 0.5] = 1

# accuracy
sum(pred.labels == test.label)/length(test.label)
