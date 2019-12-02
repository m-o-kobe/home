tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  N <- nrow(data)
  AIC <- AIC(datalm)
  R_squared<-sum$r.squared
  adjusted_R_squared<-sum$adj.r.squared
  
  result <- cbind(coe,AIC,N,R_squared,adjusted_R_squared)
  ro<-nrow(result)
  if(ro>1){
    result[2:nrow(result),5:8] <- ""
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

sp<-"pt"
data3<-subset(data2,data2$spp.x==sp)
data4<-data3[,c(3,17:26,28)]
data5<-data4[,c(1,2,12)]
data5$crd<-data4$Crd1+
  data4$Crd2+
  data4$Crd3+
  data4$Crd4+
  data4$Crd5+
  data4$Crd6+
  data4$Crd7+
  data4$Crd8+
  data4$Crd9
  
lm1<-lm(growth~.,data=data4)
lm2<-step(lm1)
lm3<-lm(growth~.,data=data5)
lm4<-step(lm3)

outcsv<-paste("nenrin/growth_bynenrin",sp,"1202.csv",sep="_")
tablecsv(lm1,data4,outcsv)
tablecsv(lm2,data4,outcsv)
tablecsv(lm3,data4,outcsv)
tablecsv(lm4,data4,outcsv)


plot(data4$past_dbh,data4$growth,main=sp)

data6<-data3
data6$pred<-lm4$residuals
#plot(data6$pred+mean(data6$growth),data6$growth,main=sp)
g<-ggplot(data=data6,aes(x=pred+mean(data6$growth),y=growth,colour=as.character(year)))+
  geom_point()+ggtitle(sp)
print(g)

#検証
data11<-subset(data1,data1$year==2000)
par(new=F) 
plot(data11$dbh01,data11$dbh/10,xlim=c(0,max(data11$dbh01)),ylim=c(0,max(data11$dbh)/10))
par(new=T) 
curve((x), 0, max(data11$dbh01),xlim=c(0,max(data11$dbh01)),ylim=c(0,max(data11$dbh)/10))
summary(data1)


#anova
anova(aov(data3$growth~data3$year))
tapply(data3$growth, data3$year, mean)  # 各グループの平均
tapply(data3$growth, data3$year, sd)  # 各グループの標準偏差
table(data3$year)


library(ggplot2)
p<-ggplot(data3,aes(x=as.character(year),y=growth,colour=as.character(year)))+
    geom_violin()+
    geom_boxplot(width=.1,fill="black",outer.colour=NA)+
    stat_summary(fun.y=mean,geom = "point", fill="white",shape=21,size=2.5)+
  ggtitle(sp)
print(p)