sms<- read.csv(file.choose(),stringsAsFactors<-F)
str(sms)
class(sms)

sms$type<-as.factor(sms$type)
sms$type<-ifelse(sms$type=="spam",1,0)
round(prop.table(table(sms$type))*100, digits<-1)
install.packages("tm")
library(tm)
sms_corpus
inspect(sms_corpus[1:3])
sms_corpus<-Corpus(VectorSource(sms$text))
inspect(sms_corpus[1:3])
corpus_clean<-tm_map(sms_corpus, tolower) 
corpus_clean<-tm_map(sms_corpus, tolower)                   
corpus_clean<-tm_map(corpus_clean, removeNumbers)            
corpus_clean<-tm_map(corpus_clean, removeWords, stopwords()) 
corpus_clean<-tm_map(corpus_clean, removePunctuation)        
corpus_clean<-tm_map(corpus_clean, stripWhitespace)          
inspect(corpus_clean[1:3])
corpus_clean$content[1:10]
#corpus_clean<-tm_map(corpus_clean, PlainTextDocument) 
corpus_clean<-Corpus(VectorSource(corpus_clean))
dtm<-DocumentTermMatrix(corpus_clean)
dtm<-as.matrix(dtm)
sms.train<-sms[1:4169, ] 
sms.test <-sms[4170:5559, ] 


                
dtm.train <- dtm[1:4169,]
dtm.test <- dtm[4170:5559,]



class(dtm)


corpus.train<-corpus_clean[1:4169]
corpus.test <-corpus_clean[4170:5559]


round(prop.table(table(sms.train$type))*100)

freq_terms = findFreqTerms(dtm.train, 5)
reduced_dtm.train = DocumentTermMatrix(corpus.train, list(dictionary=freq_terms))
reduced_dtm.test =  DocumentTermMatrix(corpus.test, list(dictionary=freq_terms))
convert_counts = function(x) {
  x = ifelse(x > 0, 1, 0)
  x = factor(x, levels = c(0, 1), labels=c("No", "Yes"))
  return (x)
}

reduced_dtm.train = apply(reduced_dtm.train, MARGIN=2, convert_counts)
reduced_dtm.test  = apply(reduced_dtm.test, MARGIN=2, convert_counts)


library(e1071)

install.packages("e1071")


sms_classifier<- naiveBayes(reduced_dtm.train, sms.train$type)
sms_test.predicted<-predict(sms_classifier,
                             reduced_dtm.test)


install.packages("gmodels")     
library(gmodels)
CrossTable(sms_test.predicted,
           sms.test$type,
           prop.chisq = FALSE, 
           prop.t     = FALSE, 
           dnn        = c("predicted", "actual"))



sms_classifier2 <- naiveBayes(reduced_dtm.train,
                             sms.train$type,
                             laplace = 1)
sms_test.predicted2<-predict(sms_classifier2,
                              reduced_dtm.test)
CrossTable(sms_test.predicted2,
           sms.test$type,
           prop.chisq = FALSE, 
           prop.t     = FALSE,
           dnn        = c("predicted", "actual"))



''