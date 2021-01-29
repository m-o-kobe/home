output <-ggplot(dat, aes(V2, V3, size=V6, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=paste(title1,"Year: ",year), size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_y_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_colour_discrete(drop=FALSE)
#scale_color_manual(values = c("Larix cajanderi"="#58BE89","Betula platyphylla"="#FBA848","Populus tremula"="#40AAEF"))+
#scale_color_manual(values = c("La"="#58BE89","Be"="#FBA848","Po"="#40AAEF"))

#	scale_size_continuous(range = c(1, 6))

print( output )

library(spatstat)
pdata<-ppp(dat$V2,dat$V3,window = owin(xrange=c(0,100),yrange = c(0,50)),marks = dat$sp)


plot(pdata)
sp="Larix_cajanderi"
f1 <- function(X) { marks(X) == sp }
f2<-function(X ){marks(X)!="nodata"}

kdata<-envelope(pdata,fun = Kmulti,I=f1,J=f2,correction="Ripley",nsim = 80,nrank=2)
plot(kdata,sqrt(./pi)-r~r)
