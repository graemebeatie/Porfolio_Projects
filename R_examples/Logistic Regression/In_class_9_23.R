setwd("~/R_scripts/Logistic Regression")

# install.packages('caret')
library(pROC)
library('caret')
??caret

train = read.csv("training.csv", header = TRUE)
test = read.csv("testing.csv", header = TRUE)

data = data.frame(append(train,test))

typeof(train)
head(train)
head(test)
attach(train)

# this creates a cool report to look over the data set
# install.packages('DataExplorer')
# library(DataExplorer)
# DataExplorer::create_report(data)

# create the model with training data
Glm.Age <- glm(as.factor(FRAUD_NONFRAUD) ~ CUST_AGE, data = train, family = binomial )
summary(Glm.Age)

head(Glm.Age$fitted.values)

# probabilities using the test data
Glm.Age.probs = predict(Glm.Age, newdata =  test , type = "response") 
head(Glm.Age.probs)
summary(Glm.Age.probs)

# the min prob using age is .63 so I need to bump it higher to have better results

# check out the model using .7 as the classifier
Glm.Age.pred = ifelse(Glm.Age.probs >.72 ,"Non-Fraud","Fraud")

#Confusion matrix
# t = table(Glm.Age.pred, test$FRAUD_NONFRAUD)
# print(t)

confusionMatrix(data = as.factor(Glm.Age.pred),reference = as.factor(test$FRAUD_NONFRAUD))

# this doesnt help much
plot(CUST_AGE,as.factor(FRAUD_NONFRAUD))

# slight 
hist(CUST_AGE)
summary(CUST_AGE)

hist(TRAN_AMT)
hist(log(TRAN_AMT+1))
hist(I(TRAN_AMT^.3))

boxplot(TRAN_AMT~FRAUD_NONFRAUD)
boxplot(CUST_AGE~FRAUD_NONFRAUD)

graph_function = function(x){
  
  myPointCode <- ifelse(FRAUD_NONFRAUD=="Fraud",22,24)
  myPointColor <- ifelse(FRAUD_NONFRAUD=="Fraud","red","black")
  myLineColor <- ifelse(FRAUD_NONFRAUD=="Fraud","dark green","blue")
  survivalIndicator <- ifelse(FRAUD_NONFRAUD=="Fraud",1,0)
  jFactor <- 0.1
  plot(jitter(survivalIndicator,jFactor) ~ jitter(x, jFactor),
       ylab="Estimated Survival Probability", xlab="input X",
       main=c("Fraud vs not fraud by input X"),   
       pch=myPointCode, bg=myPointColor, col=myLineColor, cex=1, lwd=1)
  
  legend("right",legend=c("Fraud","Not_Fraud"), pch=c(22,24),
         pt.bg = c("red","black"), pt.cex=c(.7,.7), lty=c(1,2), lwd=c(1,1),
         col=c("dark green","blue"), )
}

graph_function(CUST_AGE)

################## model customer age and transaction amount ###################
Glm.Age.Amt <- glm(as.factor(FRAUD_NONFRAUD) ~ CUST_AGE + TRAN_AMT, data = train, family = binomial )
summary(Glm.Age.Amt)

Glm.Age.Amt.probs = predict(Glm.Age.Amt, newdata = test, type = 'response')
# look what a good cutoff could be based off of the summary
summary(Glm.Age.Amt.probs)
# .5 is not very good
#Glm.Age.Amt.pred = ifelse(Glm.Age.Amt.probs>.5, "Non-Fraud","Fraud")

#.65 is pretty good spec 74, sens 84, acc 79
#Glm.Age.Amt.pred = ifelse

# manually found that .81-.83 gave best results
Glm.Age.Amt.pred = ifelse(Glm.Age.Amt.probs>.80, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.Age.Amt.pred),as.factor(test$FRAUD_NONFRAUD))




# ROC curve shows that .822 for AUC for this model
test_roc = roc(as.factor(test$FRAUD_NONFRAUD) ~ Glm.Age.Amt.probs, plot = TRUE, print.auc = TRUE)
coords(test_roc, x="best", input="threshold", best.method="youden")

# best via the youden method is .5870495
Glm.Age.Amt.pred = ifelse(Glm.Age.Amt.probs>.5870495, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.Age.Amt.pred),as.factor(test$FRAUD_NONFRAUD))

################# model with log transaction amount ##########################
Glm.LogAmt <- glm(as.factor(FRAUD_NONFRAUD) ~ log(TRAN_AMT), data = train, family = binomial )
summary(Glm.LogAmt)

Glm.LogAmt.probs = predict(Glm.LogAmt, newdata = test, type = 'response')
summary(Glm.LogAmt.probs)
Glm.LogAmt.pred = ifelse(Glm.LogAmt.probs>.5, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.LogAmt.pred),as.factor(test$FRAUD_NONFRAUD))
test_roc_LogAmt = roc(as.factor(test$FRAUD_NONFRAUD) ~ Glm.LogAmt.probs, plot = TRUE, print.auc = TRUE)

Glm.LogAmt.pred = ifelse(Glm.LogAmt.probs>.5106315, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.LogAmt.pred),as.factor(test$FRAUD_NONFRAUD))

# best via the youden method is .5106315
coords(test_roc_LogAmt, x="best", input="threshold", best.method="youden")

################ model with log transaction amount and age #################

Glm.Age.LogAmt <- glm(as.factor(FRAUD_NONFRAUD) ~ log(TRAN_AMT) + CUST_AGE, data = train, family = binomial )
summary(Glm.Age.LogAmt)

Glm.Age.LogAmt.probs = predict(Glm.Age.LogAmt, newdata = test, type = 'response')
summary(Glm.Age.LogAmt.probs)
Glm.Age.LogAmt.pred = ifelse(Glm.Age.LogAmt.probs>.5, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.Age.LogAmt.pred),as.factor(test$FRAUD_NONFRAUD))
test_roc_Age_LogAmt = roc(as.factor(test$FRAUD_NONFRAUD) ~ Glm.Age.LogAmt.probs, plot = TRUE, print.auc = TRUE)

# best via the youden method is .5626843
coords(test_roc_Age_LogAmt, x="best", input="threshold", best.method="youden")

Glm.Age.LogAmt.pred = ifelse(Glm.Age.LogAmt.probs>.5626843, "Non-Fraud","Fraud")
confusionMatrix(as.factor(Glm.Age.LogAmt.pred),as.factor(test$FRAUD_NONFRAUD))

############### model with age amt and interaction between age and amount
Glm.interact <- glm(as.factor(FRAUD_NONFRAUD) ~ TRAN_AMT + CUST_AGE + TRAN_AMT:CUST_AGE, data = train, family = binomial )
summary(Glm.interact)

# the interaction was not significant so it was not included

################ comparing models with drop in deviance test

# Anova(reduced model, full) model
# p < 0.05 => choose full model
# p > 0.05 => choose reduced model

# p = 0 so the full model age and amt is better than just age
anova(Glm.Age, Glm.Age.Amt)
chi1 = (1 - pchisq(1483.6,1))
chi1


# p = 0 so the full model age and log amt is better than just age
anova(Glm.Age, Glm.Age.LogAmt)
chi4 = (1 - pchisq(3101.4,1))
chi4

# p = 2.459e-6 so the full model age and log amt is better than just log amt
anova(Glm.LogAmt, Glm.Age.LogAmt)
chi2 = (1 - pchisq(22.198,1))
chi2

# p = 1 so the reduced model log amt is better than age and amt
anova(Glm.LogAmt, Glm.Age.Amt)
chi3 = (1- pchisq(-1595.7,1))
chi3


# this means the larger model is better

# so now compare the transformed and non transformed models against each other
# using the confusion matrices and AUC
