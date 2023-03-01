ind <- sample(2, nrow(iris),
              replace = TRUE,
              prob = c(0.7, 0.3))
training <- iris[ind==1,]
testing <- iris[ind==2,]

library(ggplot2)

# might be class. Yep it was class. This was needed for knn
library(class)

# wow this is pretty neat. Does EDA of the variables
library(GGally)
ggpairs(training)

library(MASS)
linear <- lda(Species~., training)
linear
linear.pred = predict(linear,testing)
names(linear.pred)
head(linear.pred$posterior)
linear.pred$class

table(linear.pred$class, testing$Species)
#Accuracy
sum(linear.pred$class == testing$Species) / length(testing$Species)

quadratic <- qda(Species~., training)
quadratic

quadratic.pred = predict(quadratic,testing)
names(quadratic.pred)
head(quadratic.pred$posterior)
quadratic.pred$class

# this is how to pull out the class as well
table(quadratic.pred$class, testing$Species)
#Accuracy
sum(quadratic.pred$class == testing$Species) / length(testing$Species)

#Preprocessing for KNN
knn.trainx = scale(training[,c(1:4)])
knn.trainy = training$Species
knn.testx = scale(testing[,c(1:4)])
knn.testy = testing$Species

pred.knn = knn(knn.trainx,knn.testx, knn.trainy, k = 1)
table(pred.knn,knn.testy)
mean(as.character(pred.knn) == as.character(knn.testy)  )


# what is the library for KNN because it says it cant find it
# it was 'class', He uses "FNN"
pred.knn = knn(knn.trainx,knn.testx, knn.trainy, k = 98)
table(pred.knn,knn.testy)


#Best value of K?

k = c(1:length(knn.trainy))
accuracy = c()
for(i in k){
  pred.knn = knn(knn.trainx,knn.testx, knn.trainy, k = i)
  accuracy = c(accuracy, mean(as.character(pred.knn) == as.character(knn.testy)  ) )
}
plot(k,accuracy,type = 'l')


#We will use this simplier model for the example
library(VGAM) #Load package VGAM
glfit<- vglm( Species ~ Sepal.Length , family=multinomial, training)
summary(glfit)
predicted_val <- predict(glfit, testing, type="response")

apply(fitted(glfit), 1, which.max)  # Classification


