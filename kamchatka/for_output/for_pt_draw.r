#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]
#filename <-"setting/init_fire_pttest.csv"
#title1<-"before_fire"



library(ggplot2)
buf<-read.csv(filename,header=T)
dat<-buf
dat<-subset(dat,dat$dbh0>0)
dat$sp[dat$sp==1]<-"Larix cajanderi"
dat$sp[dat$sp==2]<-"Betula platyphylla"

dat$sp[dat$sp==3]<-"Populus tremula"
output <-ggplot(dat, aes(x=X.xx,y=yy, size=dbh0, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=title1, size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,90,by=10), limits=c(-2,92))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_colour_discrete(drop=FALSE)+
  scale_color_manual(values = c("Larix cajanderi"="#58BE89","Betula platyphylla"="#FBA848","Populus tremula"="#40AAEF"))
  #scale_color_manual(values = c("La"="#58BE89","Be"="#FBA848","Po"="#40AAEF"))

print(output)


g<-ggplot(data=dat,mapping=aes(x=dbh0))+
  geom_histogram(binwidth = 5,position = "dodge")+
  labs(title=title1)#+
#scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))
print(g)
