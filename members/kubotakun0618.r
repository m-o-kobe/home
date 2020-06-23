library(drc)
library(ggplot2)
data1 <-read.csv("members/yobizikkenn.csv",header=T)
sp<-"hanami"
hanag<-subset(data1,spp==sp)
hanamodel.L3 <- drm(QY ~ temp, data=hanag, fct=L.3())

sum<-summary(hanamodel.L3)
b<-sum$coefficient[1]	
d<-sum$coefficient[2]
e<-sum$coefficient[3]
data2<-data.frame(temp=seq(15,60,0.1))	
data2$qy<-d/(1+exp(b*(data2$temp-e)))
#data2_shira<-data2
#data2_tounezu<-data2
#data2_hanami<-data2

data2_shira$spp<-"shira"
data2_tounezu$spp<-"tounezu"
data2_hanami$spp<-"hanami"
data2<-rbind(data2_hanami,data2_shira,data2_tounezu)



g<-ggplot()+
  xlab("temp")+
  ylab("qy")+
  ggtitle(sp)+
  scale_x_continuous(breaks=seq(20,60,5))+
  scale_y_continuous(breaks=seq(0,1,0.1))+
  layer(
    data=data1,
    mapping=aes(x=temp,y=QY,colour=spp),
    geom="point",
    stat="identity",
    position="identity"
  )+
  layer(
    data=data2,
    mapping=aes(x=temp,y=qy,colour=spp),
    geom="line",
    stat="identity",
    position="identity"
  )

plot(g)


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
tablecsv(hanamodel.L3, hanag,"1029tsubapara-07.csv")	
