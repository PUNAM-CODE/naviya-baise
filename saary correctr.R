###################naviya byaise################
###################salary###############
salary<-read.csv(file.choose())
str( salary)
class(salary)
View(salary)
salary_test<-read.csv(file.choose())
salary_train<-read.csv(file.choose())
str(salary_test)
str(salary_train)
salary_train$educationno<-as.factor(salary_train$educationno)
salary_test$educationno<-as.factor(salary_test$educationno)
library(e1071)
salary_model<-naiveBayes(salary_train$Salary~.,data=salary_train)
salary_model
salary_model.pred<-predict(salary_model,salary_test)
salary_model.pred
mean(salary_model.pred==salary_test$Salary)
library(gmodels)
CrossTable(salary_model.pred,salary_test$Salary,prop.chisq = FALSE,prop.r = FALSE,dnn=c("predicted","actua"))
