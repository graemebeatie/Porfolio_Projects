library(Ecdat)
data(University)
head(University)
attach(University)
?University

pairs(University)

cor(University)

# looked at what things were highly correlated with undstudents
# look at the scatter plots to determine if you want to transform it (is it non-linear?)
# this is why we logged nassests as x because it looked non-linear

#inputs1 = c("acnumbers", "acrelnum","clernum", "techn","stfees", "acpay", 
#            "acrelpay", "secrpay", "admpay", "agresrk", "furneq")

plot(log(nassets),undstudents)
cor(log(nassets),undstudents) # gives 0.78


model1 = lm(undstudents~acnumbers)
summary(model1)

model1B = lm(undstudents~acrelnum)
summary(model1B)

model1C = lm(undstudents~techn)
summary(model1C)


model2 = update(model1,~.+acrelnum)
summary(model2)
plot(model2)
# this shows acrelnum is not significant so we remove it from that model

#acrelnum log x (maybe y)
plot(log(acrelnum),undstudents)

model2B = update(model1,~.+log(acrelnum) )
summary(model2B)#We prefer this model based on R^2 with the log-trans
plot(model2B)

hist(acrelnum)
hist(log(acrelnum))
plot(log(acrelnum))
plot(acrelnum)


model3 = update(model2B,~.+clernum)
summary(model3) #What should we do?

model2C = update(model2B,~.-acrelnum)
summary(model2C)


model3B = update(model2C,~.+techn)
summary(model3B) #What happened?

model3C = update(model2C,~.+stfees)
summary(model3C) #Should we include it?


#acrelpay? log x log y
plot(log(1+acrelpay),undstudents)
plot(log(1+acrelpay),log(undstudents))
plot(I(log(acrelpay)^8),undstudents) 
#Look I made a transform that made this linear lol
# this is overfitting and is not the true relationship in the data

model4A = update(model3C,~.+log(1+acrelpay))
summary(model4A) #Should we include it?

model4B = update(model3C,~.+I(log(1+acrelpay)^8))
summary(model4B) #Should we use this model?

# whenever you log transform y you get a very different model
model4C = lm(log(1+undstudents)~log(acrelnum)+clernum+stfees+log(1+acrelpay))
summary(model4C)


#secrpay x^.5 or log x (maybe y)
plot(log(secrpay),undstudents)
plot(I(secrpay^.5),undstudents)

model5A = update(model3C,~.+log(secrpay))
summary(model5A)

model5B = update(model3C,~.+I(secrpay^.5))
summary(model5B)

model5C = update(model4C,~.+log(secrpay))
summary(model5C)


#agresrk x^.5 or log x (maybe y)
plot(log(agresrk),undstudents)
plot(I(agresrk^.5),undstudents)

model6A = update(model3C,~.+log(agresrk))
summary(model6A)

model6B = update(model3C,~.+I(secrpay^.5))
summary(model6B)

model6C = update(model5C,~.+log(agresrk))
summary(model6C)


#furneq x^.5 or log x (maybe y)
plot(log(furneq),undstudents)
plot(I(furneq^.5),undstudents)

model7A = update(model3C,~.+log(furneq))
summary(model7A)

model7B = update(model3C,~.+I(furneq^.5))
summary(model7B)

model7C = update(model6C,~.+log(furneq))
summary(model7C)


model3D = update(model7A,~.-log(acrelnum))
summary(model3D)

# create a model with all of the variables being linear at first
modelfull = lm(undstudents~.,data=University)
summary(modelfull)

# you can drop a bunch at a time but you could miss things
modelfull2 = update(modelfull,~.-poststudents-stfees-landbuild)
summary(modelfull2)

modelfull3 = update(modelfull2,~.-acrelnum-clernum)
summary(modelfull3)

modelfull4 = update(modelfull3,~.-nassets)
summary(modelfull4)

modelfull5 = update(modelfull4,~.-furneq-acrelpay)
summary(modelfull5)

modelfull6 = update(modelfull5,~.-acpay-techn)
summary(modelfull6)

modelfull7 = update(modelfull6,~.-agresrk-secrpay+log(1+acrelpay)+log(secrpay)+log(agresrk)+log(furneq))
summary(modelfull7)

modelfull8 = update(modelfull7,~.-log(1 + acrelpay)-compop)
summary(modelfull8)

# if the adjusted r^2 is better choose that if they have the same amount of variables
# if they are similar in r^2 then look at the assumptions of the model (normality,etc)
# also it is better to choose the one with the least amount of transformations.

#Comparing models

# the models need to have a different number of variables to use anova
anova(modelfull6,modelfull)
anova(modelfull8,modelfull)

# the one with lower variables goes first
anova(model2C,modelfull6)

# if anova is significant that means the full (with more variables) model is better
anova(model2C,model7A)


fit_lm <- lm(formula = undstudents ~ acnumbers + secrpay + agresrk + I(resgr^0.5))


