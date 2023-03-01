attach(mtcars)
mtcars = na.omit(mtcars)
#Variable preprocessing
cor(mtcars)
pairs(mtcars)

test.index = sample(c(1:nrow(mtcars)), .3*nrow(mtcars) )

#Variables: wt, qsec, carb
#Training and test set
train.x = scale(mtcars[-test.index,c("wt","qsec","carb")])
test.x = scale(mtcars[test.index,c("wt","qsec","carb")])
train.y = mtcars[-test.index,]$mpg
test.y = mtcars[test.index,]$mpg

#Need this for KNN regression
library(FNN)
pred1 = knn.reg(train = train.x, test = test.x, y = train.y, k = 3)
pred1[[]]
RSS = mean((test.y - pred1[["pred"]] )^2)


k = c(1:length(train.y))
RSS = c()
for(i in k){
  pred1 = knn.reg(train = train.x, test = test.x, y = train.y, k = i)
  RSS = c( RSS, mean((test.y - pred1[["pred"]] )^2) )
}
plot(k,RSS,type = 'l')


bv = function(n,i,noise){
  
  
  #Training and testing data
  x = seq(0,1,by = 1/(n-1) )
  #Data generation
  truey = 2*sin(2*pi*x)
  y = 2*sin(2*pi*x)+ rnorm(length(x),0,noise)
  
  #Training and testing
  train.index = sample(c(1:length(x)),floor(.5*length(x)))
  x.train = x[train.index]
  y.train = y[train.index]
  
  x.test = x[-train.index]
  y.test = y[-train.index]
  
  plot(x.train,y.train, xlab ="x", ylab = "y")
  lines(x.test,y.test, type = 'p', pch = 16)
  lines(x,truey,type = 'l', col='red')
  
  pred1 = knn.reg(train = data.frame(x.train), test = data.frame(x.test), y = data.frame(y.train), k = i)
  RSS =  mean((y.test - as.numeric(pred1[["pred"]] )  )^2) 
  ind = order(x.test)
  lines(x.test[ind], pred1[["pred"]], type = 'l',col = 'blue')
  
  
  print('Average test error is:')
  print(RSS )
  
}

# KNN is a very flexible model if you have few neighbors

#3 little bears
# this is overfit
bv(100,1,2)

# this is better
bv(100,25,2)

# just predicts the value of the average of the dataset
# this is underfit
bv(100,50,2)








           