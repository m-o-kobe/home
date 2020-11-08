library(ggplot2)
library(spatstat)

motofire<-read.csv("fire.csv")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0

fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)

sum(fire1$D.A..2000.=="A")
sum(fire1$D.A..2000.=="D")

sp<-"La"
fire3<-subset(fire1,fire1$sp.==sp)



fire3<-subset(fire2,fire2$D.A..2000.=="A")
summary(fire3)

pppdata<-ppp(x=fire1$xx,y=fire1$yy,window=owin(c(0,90),c(0,100)),marks=fire1$D.A..2000.)
pppdata<-ppp(x=fire3$xx,y=fire3$yy,window=owin(c(0,90),c(0,100)),marks=fire3$D.A..2000.)

#D=Aかどうかを基準としたmarkcor
ms<-envelope(pppdata,fun=markcorr,f=function(m1,m2){m1==m2},nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")
ms<-envelope(pppdata,fun=markcrosscorr,f=function(m1,m2){m1==m2},i=="A",j!="A",nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")

ms<-envelope(pppdata,fun=markcorr,f=function(m1,m2){m1==m2},nsim=1000,nrank=25,normalise=FALSE,kernel="epanechnikov")



#k100<-envelope(pppdata,fun=Lest,correction="Ripley",nsim=80,nrank=2)
#plot(k100,.-r~r,main=sp, xlim=c(0,13))

#K<-envelope(pppdata,fun=Kmulti,marks(pppdata) =="A", marks(pppdata) != "A",nsim=80,nrank=2)
#作図
#plot(K,sqrt(./pi)-r~r,main=sp)

plot(ms,main="m1==m2")

valuek<-fvnames(ms,a=".")
k100as<-as.function(ms,value=valuek)

kmatome<-data.frame(r=seq(0,20,0.1))

kmatome$theo<-k100as(kmatome$r,"theo")
kmatome$obs<-k100as(kmatome$r,"obs")
kmatome$hi<-k100as(kmatome$r,"hi")
kmatome$lo<-k100as(kmatome$r,"lo")

write.csv(kmatome,"firem1==m2.csv")
