# Graeme Beatie In class assignment 9/16
library(Ecdat)
data(University)
attach(University)

# make the train and test sets
train = sample(c(1:nrow(University)), .7*nrow(University), replace = FALSE)

#training data
training_data <- University[train,]

#test data
test_data = University[-train]

# creation of model 1
model1= lm(undstudents~(I(resgr^.5)+acnumbers+secrpay+agresrk), data = University, subset =train)

# creation of model 2
model2 = lm(undstudents~I(resgr^.5)+clernum+acpay, data = University, subset = train)

# Training RSS
sum((undstudents[train]- model1$fitted.values)^2)

# Testing RSS
sum((undstudents[train]-model2$fitted.values)^2)

# Comment on which model you prefer

# From the seed that I ran the RSS of the first model was considerably lower
# than the RSS of the second model. So I would choose to use the first one
# if I was just going off of testing RSS of the models.




