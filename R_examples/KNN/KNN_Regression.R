attach(mtcars)
mtcars = na.omit(mtcars)
#Variable preprocessing
cor(mtcars)
pairs(mtcars)

# variables that are correlated with each other can be filtered out by only
# choosing the one with the highest correlation with the response variable
# to make sure that we are not adding to many dimensions to the KNN model
# so EX cyl, disp, and hp are all correlated with each other so only need one of them

test.index = sample(c(1:nrow(mtcars)), .3*nrow(mtcars) )

#Variables: wt, qsec, carb
#Training and test set

# scale so we are regressing on a unitless quantity
train.x = scale(mtcars[-test.index,c("wt","qsec","carb")])
test.x = scale(mtcars[test.index,c("wt","qsec","carb")])
train.y = mtcars[-test.index,]$mpg
test.y = mtcars[test.index,]$mpg

#Need this for KNN regression
library(FNN)
pred1 = knn.reg(train = train.x, test = test.x, y = train.y, k = 3)

pred1[]

RSS = mean((test.y - pred1[["pred"]])^2)
# units are in mpg^2
RSS
           