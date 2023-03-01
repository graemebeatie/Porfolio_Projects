mtcars
attach(mtcars)
?mtcars
head(mtcars)
pairs(mtcars)
library(stargazer)

cor(mtcars)

# good cor with mpg {wt, cyl, disp,hp,drat}

# single variable model
cor(wt,mpg)
plot(wt,mpg)
pairs(wt, mpg)

hist(wt)
hist(log(wt))
summary(wt)
summary(log(wt))

plot(I(wt^-1),mpg)


model1 = lm(mpg~wt)
summary(model1)
stargazer(model1,type = 'html', out='single var model')

# single variable model with transformation

model2 = lm(mpg~I(wt^-1))
summary(model2)
plot(model2)
stargazer(model2,type = 'html', out='single var transform')

# checking the assumptions of regression for the models
plot(model1)
shapiro.test(model1$residuals)

plot(model2)
shapiro.test(model2$residuals)

################ adding another variable to the model ###############
# cor disp = -0.847, wt = -0.867, cyl -0.85
# drat
vars2 = data.frame(mpg,wt,cyl)
pairs(vars2)

hist(cyl)
plot(cyl,mpg)
cor(cyl,mpg)
#disp
plot(I(cyl^(-1)),mpg)

hist(disp^-1)

modellogcyl = lm(log(mpg)~log(cyl))
summary(modellogcyl)

modelinvcyl = lm(mpg~I(cyl^-1))
summary(modelinvcyl)


model3A = update(model1,~.+cyl)
summary(model3A)
plot(model3A)

shapiro.test(model3A$residuals)

stargazer(model3A,type = 'html', out='2 var model')

model3B = update(model1,~.+I(cyl^-1))
summary(model3B)
plot(model3B)

shapiro.test(model3B$residuals)

stargazer(model3B,type = 'html', out='2 var transformed model')

# all variable model
model = lm(mpg~., data = mtcars)
summary(model)
plot(model)

shapiro.test(model$residuals)

stargazer(model,type = 'html', out='2 var transformed model')

# Do automatic or manual transmission vehicles have better gas mileage?
fullmodel1 = update(model,~.-am-vs-carb-cyl-drat-disp-gear-qsec)
summary(fullmodel1)

fullmodel2 = update(fullmodel1,~.-drat-I(drat^(-2)))
summary(fullmodel2)

shapiro.test(fullmodel2$residuals)

fullmodel3 = update(fullmodel2,~.-hp+I(disp^-.5)+I(hp^-1))
summary(fullmodel3)

shapiro.test(fullmodel3$residuals)

fullmodel4 = update(fullmodel3,~.-hp-I(disp^-.5))
summary(fullmodel4)

shapiro.test(fullmodel4$residuals)
plot(fullmodel4)

wtmodel = lm(mpg ~ wt+I(hp^-1))
summary(wtmodel)

wtmodel2 = lm(mpg~ wt+hp)
summary(wtmodel2)

shapiro.test(wtmodel$residuals)

# just use wt + cyl because normality works
bestmodel = lm(mpg ~wt+I(cyl^-1))
summary(bestmodel)

shapiro.test(bestmodel$residuals)

plot(bestmodel)
am_factor

# equation = 39.6863 + -3.1910(wt) + -1.5078(cyl)
# my car 2007 rav 4 is 39.6863 + -3.1910(3.5) + -1.5078(4) = 22.4866
# my cars expected mpg is 22 mpg so its pretty darn close
am
am_factor
am_factor = as.factor(am)
bestmodel2 = update(bestmodel,~.+am_factor)
summary(bestmodel2)

# for my model manual or auto does not contribute because p 
