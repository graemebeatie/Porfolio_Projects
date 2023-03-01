mtcars
attach(mtcars)
?mtcars
pairs(mtcars)

head(mtcars)

cor(mtcars)
library(ggplot2)

#p1 <- ggplot(data=mtcars) + geom_point(mapping = aes(x = mpg, y = disp))
#p1

#p1 + scale_x_continuous((trans='log10')) + scale_y_continuous(trans='log10')
#p1 + scale_x_continuous((trans='sqrt')) + scale_y_continuous(trans='sqrt')

#p1 + scale_y_sqrt()
#p4 <- p1 + scale_x_log10()
#p4
ggplot(data=mtcars) + geom_point(mapping = aes(disp, mpg))
model1 <- lm(log(mtcars$mpg)~disp)
summary(model1)
abline(model1)

plot(model1)

#install.packages('hglm')
#library('hglm')
shapiro.test(model1$residuals)

model2 <- lm(mtcars$mpg~poly(disp,2))
summary(model2)
plot(model2)

shapiro.test(model2$residuals)

model3 <- lm(mtcars$mpg~sqrt(disp))
summary(model3)
plot(model3)


ggplot(data=mtcars) + geom_point(mapping = aes(disp, log(mpg)))
ggplot(data=mtcars) + geom_point(mapping = aes(sqrt(disp), mpg))
ggplot(data=mtcars) + geom_point(mapping = aes(sqrt(disp), mpg)) + geom_abline((aes(intercept=38.8324, slope = -1.2809)))


ggplot(data=mtcars) + geom_point(mapping = aes(disp^(-1/2), mpg))
shapiro.test(model3$residuals)


histData <- c(mtcars$mpg, disp)
hist(histData)

hist(disp)


head(disp,50)
summary(disp)
plot(disp)
hist(mtcars$mpg)

histData1 <- c(mtcars$mpg, disp)
hist(histData1)

histData2 <- c(mtcars$mpg, log(disp))
hist(histData2)

histData3 <- c(mtcars$mpg, sqrt(disp))
hist(histData3)



