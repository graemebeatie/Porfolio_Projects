library('Sleuth3')
ex1029
attach(ex1029)
pairs(ex1029)
?ex1029

plot(Educ,WeeklyEarnings)
plot((Educ),log(WeeklyEarnings))

plot(Exper,WeeklyEarnings)
plot(Exper,log(WeeklyEarnings))

model1 = lm(WeeklyEarnings~Educ)
summary(model1)
# wage_notBlack = -137 + 50Edu + 132(1) because not black = 1
# -5 + 50edu

# wage_black = -137 + 50edu + 132(0)
# = -137 + 50edu

# because the difference is constant (slope = 50edu) the difference is the
# difference of the intercepts. Shown by the lines

# does the slope change based on race? (are they compensated equally with edu)
# no the slope does not change

# these matter because both the p-values are < 0.05


model2 = lm(WeeklyEarnings~Educ+Race)
summary(model2)

plot(Educ,WeeklyEarnings)
lines(c(0:18), predict(model2, 
                       newdata = data.frame("Educ" = c(0:18), Race = rep("Black",19)) ) )

lines(c(0:18), predict(model2, 
                       newdata = data.frame("Educ" = c(0:18), Race = rep("NotBlack",19)) ), col = 'red' )

# what the equations should be for model 3
# not black wage = -16 + 50edu
# black wage = 50 + 34edu

# was a plus between educ:race and was then squared before
# because the p value for the relationship : is significant so is the racenotblack category
model3 = lm(WeeklyEarnings~Educ+Race + Educ:Race)
summary(model3)


plot(Educ,WeeklyEarnings)
lines(c(0:18), predict(model3, 
                       newdata = data.frame("Educ" = c(0:18), Race = rep("Black",19)) ) )

lines(c(0:18), predict(model3, 
                       newdata = data.frame("Educ" = c(0:18), Race = rep("NotBlack",19)) ), col = 'red' )


# looking for the interaction b/w race and metropolitan status
model4 = lm(WeeklyEarnings~MetropolitanStatus+Educ+Race + Race:MetropolitanStatus)
summary(model4)


# the interaction is not likely to effect because p value is 0.702
# "we conclude H0 that the estimate could be zero"
# so we would rerun the regression without the interaction

# answer importance of each variable using the p values of the model
