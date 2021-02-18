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
levels(fire2$sp.)<-c("Betula_platyphylla","Larix_cajanderi","Populus_tremula","sos")

g<-ggplot(data=fire2,mapping=aes(x=xx,y=yy,size=dbh0,colour=sp.,shape=D.A..2000.))+
  scale_shape_manual(values=c(1,13))+
  geom_point()+
  theme_bw()+
  coord_fixed()
print(g)



g<-ggplot(data=fire2,mapping=aes(x=xx,y=yy,size=dbh0,colour=sp.))+
  labs(x="X", y="Y", title="before_fire", size="DBH", colour="Species")+
  geom_point(alpha=0.4)+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  scale_size_continuous(range = c(1, 6))+
  theme_bw()+
  coord_fixed()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,90,by=10), limits=c(-2,92))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))#+
#pdf("output/before_fire.pdf", paper ="a4", pointsize=18)
print(g)
#dev.off()
fire3<-subset(fire2,fire2$D.A..2000.=="A")
g<-ggplot(data=fire,mapping=aes(x=xx,y=yy,size=dbh0,colour=sp.))+
  labs(x="X", y="Y", title="after_fire", size="DBH", colour="Species")+
  geom_point(alpha=0.4)+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  scale_size_continuous(range = c(1, 6))+
  theme_bw()+
  coord_fixed()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,90,by=10), limits=c(-2,92))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))#+
#pdf("output/before_fire.pdf", paper ="a4", pointsize=18)
print(g)
