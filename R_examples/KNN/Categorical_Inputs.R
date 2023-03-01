
#LDA QDA KNN have a hard time with non numerical inputs

data = na.omit(titanic::titanic_train)
?titanic_train

#Training and testing
test.index = sample(c(1:nrow(data)), .3*nrow(data))

data.train = data[-test.index,]
data.test = data[test.index,]

head(data.train)
attach(data.train)

# this is still categorical data because the values represent a category
#I wonder if Passenger Class is important?
table(Pclass[Survived==1])
table(Pclass[Survived==0])


#So far we can only use numeric inputs like Age!

library('MASS')

lda1 = lda(Survived~Age, data=data.train)
lda1
plot(lda1)

lda.pred1 = predict(lda1, data.test)
lda.class1 = lda.pred1$class
table(as.factor(lda.class1),as.factor(data.test$Survived))


qda1 = qda(Survived~Age, data=data.train)
qda1

qda.pred1 = predict(qda1, data.test)
qda.class1 = qda.pred1$class
table(as.factor(qda.class1),as.factor(data.test$Survived))

#Terrible models!

#LETS TRY KNN
library('caret')

# need to scale values in KNN to make things unitless
train.x = scale(data.train[,c('Age')])
test.x = scale(data.test[,c('Age')])
train.y = as.factor(data.train[,c('Survived')])
test.y = as.factor(data.test$Survived)

KNN.model1 <- predict(caret::knn3(train.x, train.y, k = 3), test.x)
head(KNN.model1)

# converts probabilities in to predictions
knn.pred = ifelse(KNN.model1[,1]>.5,0,1)

#What is the ideal value of K?????

#Is this a good model?
table(as.factor(knn.pred), test.y)

#What if k =100?

#ROC
library(pROC)
test_roc = roc(as.factor(test.y) ~ KNN.model1[,1], 
               plot = TRUE, print.auc = TRUE)
cutoff = test_roc$thresholds[test_roc$sensitivities>.5 & test_roc$specificities >.4]
range(cutoff)
#Why is KNN better?

#Could we make a better model?

#YEs
#With data preprocessing using one hot encoding!

library(mltools)
library(data.table)

# does this deal with NAN values?
# this should just encode the categorical variables into numeric ones so probably not
newdata <- data.frame(one_hot(as.data.table(as.factor(data.train$Pclass))))
head(newdata)

# its beter to try and put these back into a dataframe
data.train = cbind(data.train,newdata)
data.test = cbind(data.test , data.frame(one_hot(as.data.table(as.factor(data.test$Pclass)))) )

lda2 = lda(Survived~Age+V1_1+V1_2+V1_3, data=data.train)
#What do they mean co linear?

# only uses two of the three because you only need 2 of 3 to identify class
lda2 = lda(Survived~Age+V1_1+V1_2, data=data.train)
lda2
plot(lda2)

lda.pred2 = predict(lda2, data.test)
lda.class2 = lda.pred2$class
table(as.factor(lda.class2),as.factor(data.test$Survived))


qda2 = qda(Survived~Age+V1_1+V1_2, data=data.train)
qda2

qda.pred2 = predict(qda2, data.test)
qda.class2 = qda.pred2$class
table(as.factor(qda.class2),as.factor(data.test$Survived))

#Better models!

#LETS TRY KNN
library('caret')

# still only uses 2 of the 3 values to help with the computation
train.x = scale(data.train[,c('Age','V1_1', "V1_2")])
test.x = scale(data.test[,c('Age','V1_1', "V1_2")])
train.y = as.factor(data.train[,c('Survived')])
test.y = as.factor(data.test$Survived)

KNN.model2 <- predict(caret::knn3(train.x, train.y, k = 3), test.x)
head(KNN.model2)
knn.pred = ifelse(KNN.model2[,1]>.5,0,1)

#What is the ideal value of K?????

#Is this a good model?
table(as.factor(knn.pred), test.y)


#Could you make a categorical variable which is if an individual is a family?
#This would be considered a transformation

# yes doing multinomial classification
# It is possible to interpret the model but it is tricky
