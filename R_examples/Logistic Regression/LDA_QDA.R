train = read.csv("training.csv", header = TRUE)
test = read.csv("testing.csv", header = TRUE)

# can just turn in an R file
head(train)
attach(train)


boxplot(TRAN_AMT~FRAUD_NONFRAUD)#This seems like a good indicator of fraud!
#Perhaps you can explain why to me

#Would a transform help?
par(mfrow=c(1,2))
boxplot((TRAN_AMT)~FRAUD_NONFRAUD, main= 'No transform')
boxplot(log(TRAN_AMT)~FRAUD_NONFRAUD, main= 'Log transform')
#Maybe?

# log transformed help with the normality of the box plot for not fraud

#Lets explor another variable
boxplot( log(ACCT_PRE_TRAN_AVAIL_BAL+1) ~ FRAUD_NONFRAUD,main= 'Log')
boxplot( (ACCT_PRE_TRAN_AVAIL_BAL) ~ FRAUD_NONFRAUD,main= 'None')

# the log transform narrows down the worry area because the 
# fraud happens on the top end. So we want transforms to separate data

boxplot( log(WF_dvc_age+1) ~ FRAUD_NONFRAUD)


#Logistic regression

#model creation and evaluation
Glm1 <- glm(as.factor(FRAUD_NONFRAUD) ~ log(TRAN_AMT), data = train, family = binomial )
summary(Glm1)

#Predicted probabilities for test data
Glm1.probs = predict(Glm1, newdata =  test , type = "response") 

#Classification rule & predicted class
glm1.pred = ifelse(Glm1.probs >.5 ,"Non-Fraud","Fraud")

#Confusion matrix
t = table(glm1.pred, test$FRAUD_NONFRAUD)
print(t)
(t[1,1]+t[2,2])/ sum(t) 
sum(glm1.pred == test$FRAUD_NONFRAUD)/ sum(t) #Another way  to calculate accuracy
t[1,1]/(t[1,1]+t[2,1]) #Recall
t[2,2]/(t[2,2]+t[1,2])#Specificity
t[1,1]/(t[1,1]+t[1,2])#Precision

#ROC curve
library(pROC)
test_roc = roc(as.factor(test$FRAUD_NONFRAUD) ~ Glm1.probs, plot = TRUE, print.auc = TRUE)

# the best reasonable range for this ROC curve is right at that corner
# so looking at the curve we want sensitivity and spec to be atleast .7
# based off of the values from the curve around the corner
names(test_roc)
#Obtain new cut off value
cutoff = test_roc$thresholds[test_roc$sensitivities>.7 & test_roc$specificities >.7]
range(cutoff)

#or

# this does the same thing but as a dataframe
roc.df = data.frame(sensitivities = test_roc$sensitivities,
                    specificities = test_roc$specificities,
                    thresholds = test_roc$thresholds)
head(roc.df)
cutoff = roc.df[roc.df$sensitivities>.7 & roc.df$specificities > .7,]

# this gives a good range for the cutoff
# go for the upper lower and middle value to see what is the best
range(cutoff$thresholds)


#What if we changed the criteria for classification
#Classification rule 2
glm1.pred2 = ifelse(Glm1.probs >.6 ,"Non-Fraud","Fraud")

#Confusion matrix
t2 = table(glm1.pred2, test$FRAUD_NONFRAUD)
print(t2)
(t2[1,1]+t2[2,2])/ sum(t2) 
t2[1,1]/(t2[1,1]+t2[2,1]) #Recall
t2[2,2]/(t2[2,2]+t2[1,2])#Specificity
t2[1,1]/(t2[1,1]+t2[1,2])#Precision


install.packages('MASS')
library('MASS')
#NEEDED for LDA and QDA

#Pre processing training and testing
data.train = data.frame(train$FRAUD_NONFRAUD,log(train$TRAN_AMT), log(train$ACCT_PRE_TRAN_AVAIL_BAL+1))
data.train[,unlist(lapply(data.train, is.numeric), use.names = FALSE)] = scale(data.train[,unlist(lapply(data.train, is.numeric), use.names = FALSE)  ] )
# make sure that the variables have the same names as the training set.
names(data.train) = c('FRAUD_NONFRAUD', "log.TRAN_AMT", "log.ACCT_PRE_TRAN_AVAIL_BAL")

# watch out that you need to scale the data first (standardizing)
data.test = data.frame(test$FRAUD_NONFRAUD,log(test$TRAN_AMT), log(test$ACCT_PRE_TRAN_AVAIL_BAL+1))
data.test[,unlist(lapply(data.test, is.numeric), use.names = FALSE)] = scale(data.test[,unlist(lapply(data.test, is.numeric), use.names = FALSE)  ] )
names(data.test) = c('FRAUD_NONFRAUD', "log.TRAN_AMT", "log.ACCT_PRE_TRAN_AVAIL_BAL")

lda.fit = lda(FRAUD_NONFRAUD~ log.TRAN_AMT + log.ACCT_PRE_TRAN_AVAIL_BAL, data = data.train)
lda.fit

plot(lda.fit)

install.packages('klaR')
library(klaR)
partimat(as.factor(FRAUD_NONFRAUD) ~ log.TRAN_AMT + log.ACCT_PRE_TRAN_AVAIL_BAL, data = data.train, method="lda")
partimat(as.factor(FRAUD_NONFRAUD)~ log(TRAN_AMT) + log(1+ACCT_PRE_TRAN_AVAIL_BAL), data = train, method="lda")

#Confusion matrix with test data
lda.pred = predict(lda.fit,  data.test)
lda.class = lda.pred$class
table(lda.class,data.test$FRAUD_NONFRAUD)
sum(lda.class == data.test$FRAUD_NONFRAUD)/nrow(data.test)

#The probabilities for each class
lda.pred$posterior
head(lda.pred$posterior)
head(lda.pred$posterior[,'Non-Fraud'])

#ROC curve
test_roc = roc(as.factor(data.test$FRAUD_NONFRAUD) ~ lda.pred$posterior[,'Non-Fraud'], plot = TRUE, print.auc = TRUE)

#Obtain new cut off value
cutoff = test_roc$thresholds[test_roc$sensitivities>.6 & test_roc$specificities >.7]
range(cutoff)


#Number of predicted control (no dieases) for cut off probability .6
sum(lda.pred$posterior >.6)
pred2 = ifelse(lda.pred$posterior[,'Non-Fraud'] > .6, "Non-Fraud", "Fraud")

table(pred2,data.test$FRAUD_NONFRAUD)

sum(pred2 == test$FRAUD_NONFRAUD)/nrow(test)



########### QDA ########################################


#qda.fit = qda(FRAUD_NONFRAUD~ (TRAN_AMT) + log(ACCT_PRE_TRAN_AVAIL_BAL+1), data = train)
qda.fit = qda(FRAUD_NONFRAUD~ log(TRAN_AMT) + log(ACCT_PRE_TRAN_AVAIL_BAL+1), data = train)
qda.fit

# didn't scale the data this time bc it doesn't do much different
# but still did the logs to make it more normal

partimat(as.factor(FRAUD_NONFRAUD)~ log(TRAN_AMT) + log(1+ACCT_PRE_TRAN_AVAIL_BAL), data = train, method="qda")
#partimat(as.factor(FRAUD_NONFRAUD)~ (TRAN_AMT) + log(1+ACCT_PRE_TRAN_AVAIL_BAL), data = train, method="qda")

#Confusion matrix with test data
qda.pred = predict(qda.fit,  test)
qda.class = qda.pred$class
table(qda.class,test$FRAUD_NONFRAUD)
sum(qda.class == test$FRAUD_NONFRAUD)/nrow(test)

#The probabilities for each class
qda.pred$posterior
head(qda.pred$posterior)
head(qda.pred$posterior[,'Non-Fraud'])

#ROC
library(pROC)
test_roc = roc(as.factor(test$FRAUD_NONFRAUD) ~ qda.pred$posterior[,2], 
               plot = TRUE, print.auc = TRUE)
cutoff = test_roc$thresholds[test_roc$sensitivities>.7 & test_roc$specificities >.7]
range(cutoff)

#Number of predicted control (no dieases) for cut off probability .6
# did not choose this for any reason that it was the lower boundary and 
# had already tried up by .5
pred2 = ifelse(qda.pred$posterior[,'Non-Fraud'] > .2, "Non-Fraud", "Fraud")
table(pred2,test$FRAUD_NONFRAUD)
sum(pred2 == test$FRAUD_NONFRAUD)/nrow(test)

#Comparing two qda models

