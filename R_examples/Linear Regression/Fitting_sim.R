x = seq(0,1,.1)
error = rnorm(length(x),0,.05)
true_y = x*(x-1)
obs_y = true_y + error

plot(x,obs_y, col = 'red')
lines(x,true_y,type = 'l')

model = lm(obs_y~poly(x,2))
summary(model)
plot(model)
lines(x,model$fitted.values,type = 'l', col='blue')
RSE = (sum(model$residuals^2)/(length(x)-2) )^.5
RSS = sum(model$residuals^2)

?c()

RSS=c()
for (i in c(1:5)) {
  model = lm(obs_y~poly(x,i))
  lines(x,model$fitted.values,type = 'l', col='blue')
  RSS = c(RSS,sum(model$residuals^2))
}       
RSS

plot(c(1:5),RSS,type = 'l',xlab="degree of polynomial")

shapiro.test(model$residuals)
