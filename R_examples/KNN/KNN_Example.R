n=5
x = runif(n,0,1)
y = runif(n,0,1)
class = ifelse(y>x,'red','black')

#Add random error!
x = x + rnorm(n,0,.1)
y = y + rnorm(n,0,.1)

df = data.frame(class,x,y)
df
plot(x,y, col = class)


dist.function = function(x,y){
  return((x^2+y^2)^.5)
}

dist.function(1,1)

all.dist = function(x,y){
  distances = data.frame(matrix(NA, nrow = length(x), ncol = length(y)))
  for (i in c(1:length(x)) ) {
    for (j in c(1:length(y)) )  {
      print(dist.function(x[i] -x[j] ,y[i]-y[j]))
      distances[i,j] = dist.function(x[i] -x[j] ,y[i]-y[j])
    }
  }
  return(distances)
}

D= data.frame( all.dist(df$x,df$y) )
D = rbind(df$class,D) 
D = cbind(c("Class" ,df$class),D)
options(digits=3)
D
