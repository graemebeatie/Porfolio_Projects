library(Ecdat)
data(University)
head(University)
attach(University)
?University

#70% = .7 of the data goes to training!
# can find other libraries/packages if we want for this class
# he slices 1 ->62 and take in .7*62 rows into the training set
# training should be for between 50-80 percent. Never below 50. 80 when you have a small dataset
# anything below 30 data points will have a hard time generating a model. So comment on how much data you have
train = sample(c(1:nrow(University)), .7*nrow(University), replace = FALSE)
?sample
# this is just a list of rows!!! not your data. train is the indexes of the sampled values

#training data
training_data <- University[train,]

#test data
test_data = University[-train]


# replace = False is the default but you should use it. Having true would allow
# for the same datapoint to be used multiple times. Which we don't want rn

#Use training data to make your models

#Model 1
plot(clernum[train],undstudents[train], main = 'No Transform')
model1 = lm(undstudents~clernum, data = University, subset = train)
summary(model1)
#Error
sum((undstudents[train]- model1$fitted.values)^2) / length(train)

#Model 2
plot(log(clernum[train]),undstudents[train], main = "Log transform")
model2 = lm(undstudents~ log(clernum), data = University, subset = train)
summary(model2)

#Error
sum((undstudents[train]-model2$fitted.values)^2) / length(train)
# if you remove / length(train) it would just be RSS
# could sqrt the value to get an r instead of an r^2


#Model evaluation is on test data

#Model1
sum((undstudents[-train]- 
       predict(model1,newdata = data.frame(clernum = clernum))[-train])^2) / length(train)

#Model 2
sum((undstudents[-train]- 
       predict(model2,newdata = data.frame(clernum = clernum))[-train])^2) / length(train)

#Here is another way to use training and testing data
install.packages('caTools')
library(caTools)

#Use 70% of dataset as training set and remaining 30% as testing set
sample <- sample.split(University$undstudents, SplitRatio = 0.7)

data.train = subset(University, sample == TRUE )
data.test = subset(University, sample == FALSE )


#Model 1
model1 = lm(undstudents~clernum, data = data.train)
summary(model1)
#Error
sum((data.train$undstudents-model1$fitted.values)^2) / nrow(data.train)

#Model 2
model2 = lm(undstudents~ log(clernum), data = data.train)
summary(model2)

#Error
sum((undstudents[train]-model2$fitted.values)^2) / nrow(data.train)


#Model evaluation is on test data

#Model1
sum((data.test$undstudents- 
       predict(model1,newdata = data.frame(clernum = data.test$clernum))   )^2) / nrow(data.test)

#Model 2
sum((data.test$undstudents - 
       predict(model2,newdata = data.frame(clernum = data.test$clernum))   )^2) / nrow(data.test)



