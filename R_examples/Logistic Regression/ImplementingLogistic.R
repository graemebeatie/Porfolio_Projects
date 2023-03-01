setwd("~/R_scripts/Logistic Regression")

train = read.csv("training.csv", header = TRUE)
test = read.csv("testing.csv", header = TRUE)

head(train)
head(test)
attach(train)

#Lets explore a single variable ... the rest is for you!

boxplot(TRAN_AMT~FRAUD_NONFRAUD)#This seems like a good indicator of fraud!
#Perhaps you can explain why to me

#Would a transform help?
boxplot(log(TRAN_AMT)~FRAUD_NONFRAUD)
#Maybe? he just said to run the model and see. Transformations are possible because this is skewed

# we don't care about date time variables for this project
# did a mean thing

## GRAPHICAL DISPLAY FOR PRESENTATION 
# all this is kind of a pain in the ass so he gave us the easier way below
myPointCode <- ifelse(FRAUD_NONFRAUD=="Fraud",22,24)
myPointColor <- ifelse(FRAUD_NONFRAUD=="Fraud","red","black")
myLineColor <- ifelse(FRAUD_NONFRAUD=="Fraud","dark green","blue")
survivalIndicator <- ifelse(FRAUD_NONFRAUD=="Fraud",1,0)
jFactor <- 0.1
plot(jitter(survivalIndicator,jFactor) ~ jitter(TRAN_AMT, jFactor),
     ylab="Estimated Survival Probability", xlab="input X",
     main=c("Fraud vs not fraud by input X"), xlim=c(15,75),   
     pch=myPointCode, bg=myPointColor, col=myLineColor, cex=1, lwd=1)

legend("right",legend=c("Fraud","Not_Fraud"), pch=c(22,24),
       pt.bg = c("red","black"), pt.cex=c(.7,.7), lty=c(1,2), lwd=c(1,1),
       col=c("dark green","blue"), )


sample_function = function(x,y){
  print('This is a sample function it executes the same code here everytime!')
  print('This function returns the addition of x and y that you input')
  return(x+y)
}
sample_function(2,3)

# made a function for us so we didn't have to run all the code
# he doesn't think this will be super useful for this project but maybe for other
# datasets that are so large or are betterly separated
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

graph_function(TRAN_AMT)
graph_function(log(TRAN_AMT) )

# a lot of variables show that they are significant so p-values won't be that helpful

#model creation and evaluation
# could use other models using this formula of general linear model
# a logistic regression function just spits out a probability
# so we need a classification criteria to split the data set
Glm1 <- glm(as.factor(FRAUD_NONFRAUD) ~ TRAN_AMT, data = train, family = binomial )
summary(Glm1)

head(Glm1$fitted.values)

Glm1.probs = predict(Glm1, newdata =  test , type = "response") 
head(Glm1.probs)
# the output is probabilities that will be categorized using the below if else

#Classification rule
# MAKE SURE THE STRING MATCHES YOUR RESPONSE VARIABLE
glm1.pred = ifelse(Glm1.probs >.5 ,"Non-Fraud","Fraud")

#Confusion matrix
t = table(glm1.pred, test$FRAUD_NONFRAUD)
print(t)
# this gives the accuracy
#but accuracy is a really bad for highly skewed data sets like this.
# could find a package or make a function to spit out prec, specificity, and such
(t[1,1]+t[2,2])/ sum(t) 

#What if we changed the criteria for classification to make it stricter
#Classification rule 2
glm1.pred2 = ifelse(Glm1.probs >.75 ,"Non-Fraud","Fraud")

#Confusion matrix
t2 = table(glm1.pred2, test$FRAUD_NONFRAUD)
print(t2)
(t2[1,1]+t2[2,2])/ sum(t2) 


#ROC curve
library(pROC)
test_roc = roc(as.factor(test$FRAUD_NONFRAUD) ~ Glm1.probs, plot = TRUE, print.auc = TRUE)

coords(test_roc, "best")
coords(test_roc, x="best", input="threshold", best.method="youden") # Same than last line
