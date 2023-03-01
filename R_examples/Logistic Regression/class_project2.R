library(readxl)

#Get data from excel files
#train <- read_excel("train.xlsx")
#test <- read_excel("test.xlsx")

# get the variables
variables <- read_excel("variable.xlsx")

train <- read.csv('training.csv')
test <- read.csv('training.csv')

train = data.frame(train)

head(train)

model1 = glm( as.factor(FRAUD_NONFRAUD) ~ TRAN_AMT + STATE_PRVNC_TXT, data = train, family = binomial )
summary(model1)

#
