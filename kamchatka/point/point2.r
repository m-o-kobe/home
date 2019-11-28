library(spatstat)
sp<-"pt"

data<-read.csv("ctrl0315.csv")
datap<-subset(data,data$spp==sp)
datap<-subset(datap,datap$dbh01>0)
pppdata<-ppp(x=datap$x,y=datap$y,window=owin(c(0,100),c(0,50)),marks=datap$dbh01)

data<-read.csv("int0313.csv")
datap<-subset(data,data$spp==sp)
datap<-subset(datap,datap$dbh01>0)
pppdata<-ppp(x=datap$x,y=datap$y,window=owin(c(0,50),c(-50,50)),marks=datap$dbh01)


#単樹種のL関数
ms<-envelope(pppdata,fun=markcorr,nsim=80,nrank=2)
#作図
#plot(k100,sqrt(./pi)~r)
plot(ms,main=sp)

#csv出力用
valuek<-fvnames(k100,a=".")
k100as<-as.function(k100,value=valuek)
kmatome<-data.frame(r=seq(0,12,0.05))
kmatome$theo<-k100as(kmatome$r,"theo")
kmatome$obs<-k100as(kmatome$r,"obs")
kmatome$hi<-k100as(kmatome$r,"hi")
kmatome$lo<-k100as(kmatome$r,"lo")
write.csv(kmatome,"ctrl_lc.csv")

png("../../harasan.png",height=960, width=960, res=144)
plot(k100,.-r~r,main="")
dev.off()

vardata<-varblock(pppdata, fun = Lest,
                  confidence=0.95)
plot(vardata,.-r~r)

g<-ggplot(data,mapping=aes(x=y,y=x,colour=spp,size=dbh01))+
  geom_point(alpha=0.5)+
  coord_fixed()
print(g)