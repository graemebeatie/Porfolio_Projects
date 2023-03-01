library('Sleuth3')
?ex0728
tail(ex0728)
attach(ex0728)

model = lm(Activity~Years)
shapiro.test(model$residuals)
summary(model)
plot(model)
plot(Years,Activity)
abline(model)

detach(ex0728)

#y = 8.38 + .99*years

?ex0730
attach(ex0730)
head(ex0730)
model = lm(Refusal~Age) 
shapiro.test(model$residuals)
plot(model)  
summary(model)
plot(Age, Refusal)
abline(model)

# y = (-0.002)*25 + .44
detach(ex0730)

predict(model, newdata = data.frame(Age = 25))


bv = function(n,p,noise){
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
  
  model = lm(y.train~poly(x.train,p))
  ind = order(x.train)
  lines(x.train[ind], model$fitted.values[ind], type = 'l',col = 'blue')
  
  print('Average training error is')
  print(sum(model$residuals^2)/length(model$residuals) )
  
  print('Average test error is:')
  data = data.frame(x.test)
  names(data) = 'x.train'
  pred = predict(model, newdata = data )
  print(sum((y.test - pred)^2/length(y.test) ) )
  
}


bv(100,1,.1)
bv(100,2,.1)
bv(100,3,.1)

bv(20,1,.2)
bv(20,5,.2)
bv(20,9,.2)

bv(100,1,2)
bv(100,5,2)


model = lm(mpg~. , data = mtcars)

summary(model)


