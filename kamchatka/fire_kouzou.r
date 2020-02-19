library(doBy)
library(dplyr)
library(spatstat)
library("colorRamps")
library(ggplot2)

tc <- colourmap(matlab.like2(30), breaks=seq(0.0,1.01,length=31))
tc1 <- colourmap(matlab.like2(30), breaks=seq(0.0,0.31,length=31))




motofire<-read.csv("fire_maiboku.csv", fileEncoding = "UTF-8-BOM")
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
fire2<-subset(fire3,fire3$da==0)
pppfire1<-ppp(fire3$xx,fire3$yy,window=owin(c(0,90),c(0,100)))
denfire1<-density(pppfire1,sigma=5.8)
pppfire2<-ppp(fire2$xx,fire2$yy,window=owin(c(0,90),c(0,100)),marks=fire2$D.A..2000.)
denfire2<-density(pppfire2,sigma=5.8)

#plot(denfire1,col=tc1,axes=TRUE,main=title,asp=1)

#plot(denfire2/denfire1,col=tc,axes=TRUE,main=title,asp=1)

intensity1<-denfire2/denfire1
fire_intensity3<-as.vector(intensity2)

fire3<-fire1
#fire3<-subset(fire1,fire1$sp.=="Be")
fire3<-subset(fire1,fire1$dbh0<=10)
fire3<-subset(fire3,fire3$dbh0>0)
#fire2<-subset(fire3,fire3$da==0)
pppfire1<-ppp(fire3$xx,fire3$yy,window=owin(c(0,90),c(0,100)))
denfire1<-density(pppfire1,sigma=5.8)
#pppfire2<-ppp(fire2$xx,fire2$yy,window=owin(c(0,90),c(0,100)),marks=fire2$D.A..2000.)
#denfire2<-density(pppfire2,sigma=5.8)

#intensity1<-denfire2/denfire1
intensity_<-denfire1$v
intensity0_10<-as.vector(intensity_)
plot(denfire1)

model1<-lm(fire_intensity3~intensity0_10+intensity10_20+intensity20_+intensity_bp+intensity_lc+intensity_pt)
summary(model1)
step()
fire_iroiro<-cbind(fire_intensity3,intensity0_10,intensity10_20,intensity20_,intensity_lc,intensity_bp,intensity_pt)
library(GGally)
fire_iroiro<-as.data.frame(fire_iroiro)
g1<-ggpairs(fire_iroiro)
print(g1)
