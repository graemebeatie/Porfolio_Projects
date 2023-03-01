install.packages('datarium')
library('datarium')
marketing

head(marketing)
?marketing
attach(marketing)

pairs(sales~., data = marketing)

#K fold cross validation
install.packages('boot')
library(boot)
set.seed(17)

glm.fit1 <- glm(log(sales)~facebook+youtube, data = marketing)
cv.error.1 <- cv.glm(marketing, glm.fit1, K=5)$delta[1] #K = number of folds
#The other model
glm.fit2 <- glm(log(sales)~(facebook+youtube)^2, data = marketing)
cv.error.2 <- cv.glm(marketing, glm.fit2, K=5)$delta[1] #K = number of folds

cv.error.1
cv.error.2



#LOOCV
glm.fit1 <- glm(log(sales)~facebook+youtube, data = marketing)
LOOCV.error.1 <- cv.glm(marketing, glm.fit1)$delta[1] 
#The other model
glm.fit2 <- glm(log(sales)~(facebook+youtube)^2, data = marketing)
LOOCV.error.2 <- cv.glm(marketing, glm.fit2)$delta[1] 

LOOCV.error.1
LOOCV.error.2


test.index = c(105, 174, 46, 104, 1, 12, 96, 69, 130, 55, 18, 17, 58, 99, 143, 100, 158, 153, 191, 24, 10, 86, 101, 197, 167, 8, 168, 29, 98, 155, 52, 63, 102, 151, 72, 117, 49, 120, 92, 110, 54, 173, 11, 125, 32, 189, 59, 196, 16, 40)

#Models
model1 = lm(log(sales)~facebook+youtube, data = marketing, subset = -test.index)
model2 = lm(log(sales)~ (facebook+youtube)^2, data = marketing, subset = -test.index)

one_boot = function( model1, model2, index){
  boot.index = sample(index, length(index), replace = TRUE)
  error1 = sum(marketing[boot.index,'sales'] - exp(predict(model1, data = marketing[boot.index,])) )^2 /length(boot.index)
  error2 = sum(marketing[boot.index,'sales'] - exp(predict(model2, data = marketing[boot.index,])) )^2 / length(boot.index)
  return(c(error1,error2))
}

one_boot(model1, model2, test.index)


m_boots = function(m,model1, model2, test.index){
  error1 = c(1:m)
  error2 = c(1:m)
  for (i in 1:m) {
    boot =  one_boot(model1, model2, test.index)
 
    error1[i] = boot[1]
    error2[i] = boot[2]
  }#End of for
  return(cbind(error1,error2))
}

bs = m_boots(200, model1, model2, test.index )
stderr(bs)
#Averages
sum(bs[1,])/nrow(bs)
sum(bs[2,])/nrow(bs)





library('Sleuth3')
head(ex2012)
?ex2012
attach(ex2012)


#test.index = sample(c(1:dim(ex2012)[1]),.2*dim(ex2012)[1], replace = FALSE  )
#comma_vec <- paste(test.index, collapse = ", ")
test.index = c(117, 45, 90, 40, 66, 41, 8, 25, 95, 20, 110, 84, 5, 74, 111, 55, 56, 79, 29, 2, 1, 60, 69, 58)

install.packages('Mass')
library('MASS')
#NEEDED for LDA and QDA
lda.fit1 = lda(Group~log(CK)+H, data = ex2012, subset = -test.index)
lda.fit2 = lda(Group~(log(CK)+H)^2, data = ex2012, subset = -test.index)

#Confusion matrix with bootstrap data
A1 = c(1:100)
A2 = c(1:100)
for (i in 1:100) {
  boot.index = sample(test.index, length(test.index), replace = TRUE)
  lda.pred1 = predict(lda.fit1,  ex2012[boot.index,])
  lda.class1 = lda.pred1$class
  lda.pred2 = predict(lda.fit2,  ex2012[boot.index,])
  lda.class2 = lda.pred2$class
  A1[i] = mean(lda.class1==ex2012[boot.index,]$Group) #bootstrap accuracy
  A2[i] = mean(lda.class2==ex2012[boot.index,]$Group) #bootstrap accuracy
  
}

mean(A1)
mean(A2)

