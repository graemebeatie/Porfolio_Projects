


#What order of polynomial should we use?
#Using training data what order should we choose?


#drat
plot(drat,mpg)
modeld1 = lm(mpg~drat)
summary(modeld1)
abline(modeld1)
#assumptions
plot(modeld1)
shapiro.test(modeld1$residuals)


modeld2 = lm(mpg~ poly(drat,2))
summary(modeld2)
plot(modeld2)
shapiro.test(modeld2$residuals)


plot(drat,log(mpg))
modeld = lm(log(mpg)~ drat)
summary(modeld)
plot(modeld)
shapiro.test(modeld$residuals)


#Assumptions met?


#hp
plot(hp,mpg)
modelhp1 = lm(mpg~hp)
summary(modelhp1)
plot(modelhp1)
shapiro.test(modelhp1$residuals)

hpt = 1/hp
plot(hpt,mpg,main = "1/x transform", xlab = '1/hp')
modelhpt = lm(mpg~ hpt )
summary(modelhpt)
plot(modelhpt)
shapiro.test(modelhpt$residuals)

modelhp2 = lm(mpg~ poly(hp,2))
summary(modelhp2)
plot(modelhp2)

plot(log(hp),log(mpg))
modelhp = lm(log(mpg)~ log(hp))
summary(modelhp)
plot(modeld)


modelm1 = lm(mpg~hpt+drat)
summary(modelm1)
plot(modelm1)


modelm2 = lm(log(mpg)~log(hp)+drat)
summary(modelm2)
plot(modelm2)


cor(mtcars)

library('car')
model = lm(mpg~., data = mtcars)
summary(model)
vif(model)
