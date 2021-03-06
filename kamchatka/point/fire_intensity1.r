library(doBy)
library(dplyr)
library(spatstat)
library("colorRamps")
library(ggplot2)
library(MuMIn)

tc <- colourmap(matlab.like2(30), breaks=seq(0.0,1.01,length=31))
tc1 <- colourmap(matlab.like2(30), breaks=seq(0.0,0.31,length=31))




motofire<-read.csv("fire_maiboku0212.csv")
#fire_sprout1<-read.csv("fire_bp_sprout.csv", fileEncoding = "UTF-8-BOM")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1


pppfire<-ppp(fire1$xx,fire1$yy,window=owin(c(0,90),c(0,100)),marks=fire1$D.A..2000.)
plot(density(pppfire,sigma=5.8))



fire3<-fire1

title="all"
#fire3<-subset(fire1,fire1$sp.=="Be")
#fire3<-subset(fire1,fire1$dbh0<=10)
#fire3<-subset(fire3,fire3$dbh0>0.0)
fire2<-subset(fire3,fire3$da==0)
pppfire1<-ppp(fire3$xx,fire3$yy,window=owin(c(0,90),c(0,100)))
denfire1<-density(pppfire1,sigma=5.8,eps=c(1,1))
pppfire2<-ppp(fire2$xx,fire2$yy,window=owin(c(0,90),c(0,100)),marks=fire2$D.A..2000.)
denfire2<-density(pppfire2,sigma=5.8,eps=c(1,1))


plot(denfire1,col=tc1,axes=TRUE,main=title,asp=1)
plot(denfire2,col=tc1,axes=TRUE,main=title,asp=1)

plot(denfire2/denfire1,col=tc,axes=TRUE,main=title,asp=1)

intensity1<-denfire2/denfire1
intensity2<-intensity1$v
intensity3<-t(intensity2)


fire4<-subset(fire1,fire1$xx>0.0 && fire1$xx<90.0 && fire1$yy>0.0 &&fire1$yy<1000)
fire4$fire<-0
len<-nrow(fire4)
#write.csv(intensity3,"fire_intensity.csv", row.names = FALSE,col.names = FALSE)
#write.table(intensity2, file="fire_intensity.csv", row.names=FALSE, col.names=FALSE)


for(i in 1:len){
  print(i)
  fire_intensity<-intensity2[as.integer(fire4$yy[i]+1),as.integer(fire4$xx[i]+1)]
  fire4$fire[i]<-as.numeric(fire_intensity)
}
#fire4$fire_intense<-0
#fire4$fire_intense[fire4$fire>0.8240]<-1
sp<-"Po"
fire_sp<-subset(fire4,fire4$sp.==sp)
#fire_sp<-fire4
fire_sp<-subset(fire_sp,!is.na(fire_sp$fire))


model1<-glm(formula=da~fire*dbh0+0,data=fire_sp,family="binomial")
summary(model1)
model2<-glm(formula=da~dbh0,data=fire_sp,family="binomial")
summary(model2)



options(na.action = "na.fail")

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)


outcsv<-paste("mortality/mortality",sp,"0228.csv",sep="_")
write.csv(model_hikaku,outcsv)
tablecsv(model2,fire_sp,outcsv)



model2<-step(model1)
summary(model2)


g<-ggplot(data=fire_sp,aes(x=dbh0,y=fire,color=D.A..2000.))+
  ggtitle(sp)+
  geom_point()
print(g)

len=nrow(fire3)
for(i in 1:len){
  print(i)
  fire_intensity<-intensity3[as.integer(fire3$xx[i])+1,as.integer(fire3$yy[i])+1]
  fire3$fire[i]<-as.numeric(fire_intensity)
}
write.csv(fire3,"fire_maiboku0302.csv")
          

class(intensity2)
intensity3<-as.vector(intensity2)

datalm<-model1
data=fire_sp
ou="test.csv"
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
    result[2:nrow(result),5:6] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

