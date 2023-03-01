train = read.csv("training.csv", header = TRUE)
test = read.csv("testing.csv", header = TRUE)

boxplot(train$WF_dvc_age ~train$FRAUD_NONFRAUD)

#KNN classification
# install.packages('caret')
library('caret')

#training and testing

# he chose these values because they are numeric
train.x = scale(train[,c(2,3,6)])
test.x = scale(test[,c(2,3,6)])
train.y = as.factor(train[,c('FRAUD_NONFRAUD')])
test.y = as.factor(test$FRAUD_NONFRAUD)

model1 <- predict(caret::knn3(train.x, train.y, k = 3), test.x)
head(model1)
knn.pred = ifelse(model1[,1]>.5,'Fraud','Non-Fraud')

#What is the ideal value of K?????

#Is this a good model?
table(knn.pred, test.y)

# pretty darn good, but we can't determine what variables matter the most
# so it is predictive but not interpretable

#ROC Curve
library('pROC')
test_roc1 = roc(as.factor(test$FRAUD_NONFRAUD) ~ model1[,1], 
                plot = TRUE, print.auc = TRUE)


cutoff = test_roc1$thresholds[test_roc1$sensitivities>.85 & test_roc1$specificities>.8]
range(cutoff)

#Lets see what happends if we change it

# if you change ,1 to 2 you get the complement of how much not fraud
knn.pred = ifelse(model1[,1]>.2,'Fraud','Non-Fraud')

#Is this a good model?
table(knn.pred, test.y)


##K=12600 -->NOOOOO 
#What happens id K = number of test data?
#K=400

model2 <- predict(caret::knn3(train.x, train.y, k = 400), test.x)
knn.pred2 = ifelse(model2[,1]>.5,'Fraud','Non-Fraud')
table(knn.pred2, test.y)

test_roc2 = roc(as.factor(test$FRAUD_NONFRAUD) ~ model2[,1], 
                plot = TRUE, print.auc = TRUE)


cutoff = test_roc2$thresholds[test_roc2$sensitivities>.75 & test_roc2$specificities>.6]
range(cutoff)

knn.pred2 = ifelse(model2[,1]>.3,'Fraud','Non-Fraud')

table(knn.pred2, test.y)



k = seq(from = 5, to=100, by = 20)
accuracy = c()
for (i in k ) {
  model2 <- predict(caret::knn3(train.x, train.y, k = i), test.x)
  knn.pred2 = ifelse(model2[,1]>.5,'Fraud','Non-Fraud')
  accuracy = c(accuracy,sum(knn.pred2 == test.y) / length(test.y) )
}

info = cbind(k,accuracy)
tail(info)

#Could we use other criteria?
plot(k, accuracy)





