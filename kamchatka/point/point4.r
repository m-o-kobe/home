library(ggplot2)
library(spatstat)

motofire<-read.csv("fire.csv")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0

fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)



summary(fire2)
sp<-"Be"
fire3<-subset(fire2,fire2$sp.==sp)



fire3<-subset(fire2,fire2$D.A..2000.=="A")
summary(fire3)

pppdata<-ppp(x=fire2$xx,y=fire2$yy,window=owin(c(0,90),c(0,100)),marks=fire2$D.A..2000.)
pppdata<-ppp(x=fire3$xx,y=fire3$yy,window=owin(c(0,90),c(0,100)),marks=fire3$D.A..2000.)

#D=Aかどうかを基準としたmarkcor
ms<-envelope(pppdata,fun=markcorr,f=function(m1,m2){m1==m2},nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")


k100<-envelope(pppdata,fun=Lest,correction="Ripley",nsim=80,nrank=2)
plot(k100,.-r~r,main=sp, xlim=c(0,13))

K<-envelope(pppdata,fun=Kmulti,marks(pppdata) =="A", marks(pppdata) != "A",nsim=80,nrank=2)
#作図
plot(K,sqrt(./pi)-r~r,main=sp)

plot(ms,main=sp)


