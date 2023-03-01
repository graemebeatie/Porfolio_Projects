library(Ecdat)
data(University)
head(University)
attach(University)
?University

pairs(University)

cor(University)

# could look at a model with resgr(.70), stfees(0.885), clernum
model1A = lm(undstudents~I(resgr^.5))
summary(model1A)

model1B = lm(undstudents~stfees)
summary(model1B)

model1C = lm(undstudents~clernum)
summary(model1C)

model2A = update(model1A,~.+stfees)
summary(model2A)

model2B = update(model1A,~.+clernum+stfees)
summary(model2B)

# this has secrpay as insig
model3A = update(model2B,~.+secrpay)
summary(model3A)

# this has res,cler,and acp as sig, but stfees is not
model3B = update(model2B,~.+acpay)
summary(model3B)

# works this will be my first model
model3C = update(model3B,~.-stfees)
summary(model3C)
vars <- data.frame(undstudents,I(resgr^.5),clernum,acpay)
pairs(vars)

cor(I(resgr^.5),undstudents)
hist(resgr)
hist(I(resgr^.5))

# now work backwards from a full model
modelfull = lm(undstudents~.,data=University)
summary(modelfull)

modelfull1 = update(modelfull,~.-resgr)
summary(modelfull1)

modelfull2 = update(modelfull1,~.-stfees-nassets-clernum)
summary(modelfull2)

modelfull3 = update(modelfull2,~.-landbuild-acrelnum-furneq)
summary(modelfull3)

modelfull4 = update(modelfull3,~.-compop-admpay-poststudents)
summary(modelfull4)

# add this last
modelfull5 = update(modelfull4,~.+I(resgr^.5)-acrelpay)
summary(modelfull5)

modelfull6 = update(modelfull5,~.-techn-acpay)
summary(modelfull6)

vars2 = data.frame(undstudents,acnumbers,secrpay,agresrk,I(resgr^.5))
pairs(vars2)

anova1 <- anova(model3C,modelfull6)

install.packages("stargazer")
library(stargazer)
#stargazer(model3C, type = "text", out = "model3C_summary")

#stargazer(modelfull6, type = "html", out = "model3C_summary")
# get the html string and put it into an html reader online to get the image of table
#stargazer(anova1, type = "html", out = "model3C_summary")
