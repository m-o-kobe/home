
tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  N <- nrow(data)
  aic <- AIC(datalm)
  result <- cbind(coe,aic,N)
  ro<-nrow(result)
  if(ro>1){
    result[2:nrow(result),5:6] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}


motodata2<-read.csv("crd/crd_int_191128.csv")
#motodata<-read.csv("nenrin/nenrin1.csv")
motodata<-read.csv("nenrin/nenrin3.csv" ,header=T, fileEncoding="UTF-8-BOM")

data1<-merge(motodata,motodata2,by="num")
data1$past_dbh<-data1$dbh01-data1$fromsoto/5
data2<-subset(data1,data1$year>=1996)

sp<-"lc"

data3<-subset(data2,data2$spp.x==sp)
data4<-data3[,c(3,17:26,28)]

lm1<-lm(growth~.,data=data4)
summary(lm1)
lm2<-step(lm1)
summary(lm2)
outcsv<-paste("nenrin/growth_bynenrin",sp,"1129.csv",sep="_")
tablecsv(lm1,data4,outcsv)
tablecsv(lm2,data4,outcsv)


plot(data4$past_dbh,data4$growth,main=sp)


#検証
data11<-subset(data1,data1$year==2000)
par(new=F) 
plot(data11$dbh01,data11$dbh/10,xlim=c(0,max(data11$dbh01)),ylim=c(0,max(data11$dbh)/10))
par(new=T) 
curve((x), 0, max(data11$dbh01),xlim=c(0,max(data11$dbh01)),ylim=c(0,max(data11$dbh)/10))
summary(data1)
