library(ggplot2)
library(spatstat)

motofire<-read.csv("fire.csv")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0

fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)

#作図用
fire2<-subset(fire1,fire1$dbh0>0)
g<-ggplot(data=fire2,mapping=aes(x=xx,y=yy,size=dbh0,colour=sp.,shape=D.A..2000.))+
  scale_shape_manual(values=c(1,13))+
  geom_point()+
  coord_fixed()
print(g)