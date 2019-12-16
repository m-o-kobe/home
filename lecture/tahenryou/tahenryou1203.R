library(GGally)
df1<-read.table("serena4.dat",header=TRUE)
df2<-df1[3:7]
df3<-df1[3:12]
df4<-df3
df4[6:7]<-ifelse(df3[6:9]==1,"1","0")
df4[4]<-ifelse(df3[4]==1,"1","0")




g<-ggpairs(data=df4,diag=list(continuous="barDiag"))
print(g)
fit1<-lm(総車両価格~.,data=df3)
summary(fit1)
fit2<-step(fit1)
summary(fit2)
fit3<-lm(総車両価格~.,dat=df2)
summary(fit2)
df5<-df3[1:4]
df5$residual<-fit2$residuals
par(mfrow=c(2,2))
plot(fit2)
