install.packages("ggvis")

library(ggvis)
library(rvest)
library(dplyr)
library(broom)
library(lmodel2)
library(smatr)

df1<-read.csv("kano.csv")

df2<-subset(df1,df1$x2=="b")

#model1<-lmodel2(y~x1,data=df2)
#summary(model1)
#model1$regression.results

model2<-sma(y~x1,data=df2)
summary(model2)
