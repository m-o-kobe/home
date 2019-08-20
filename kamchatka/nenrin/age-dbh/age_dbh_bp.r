library(ggplot2)
args<-commandArgs(trailingOnly=T)
sp<as.character(args[1])
outpic<-args[2]

motodata<-read.csv("../nenrin.csv")
data<-subset(motodata,spp==sp)
taus <- c(.01,.05,.25,.05, .75,.95,.99)
buniten<-rq( (data$age) ~ (data$dbh), tau=taus)
f<-coef(buniten)
kaiki001<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,1]+f[1,1],
tau="0.01")

kaiki005<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,2]+f[1,2],
tau="0.05")

kaiki025<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,3]+f[1,3],
tau="0.25")

kaiki050<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,4]+f[1,4],
tau="0.50")

kaiki075<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,5]+f[1,5],
tau="0.75")
kaiki095<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,6]+f[1,6],
tau="0.95")
kaiki099<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
age=seq(min(data$dbh),max(data$dbh),10)*f[2,7]+f[1,7],
tau="0.99")

kaiki<-rbind(kaiki001,kaiki005,kaiki025,kaiki050,kaiki075,kaiki095,kaiki099)
g<-ggplot()+
ggtitle(sp)+
  layer(
    data=data,
    mapping=aes(x=dbh,y=age,alpha=0.01),
    geom="point",
    stat="identity",
    position="identity"
  )+
  layer(
    data=kaiki,
    mapping=aes(x=dbh,y=age,colour=tau),
    geom="line",
    stat="identity",
    position="identity"
  )


p<-ggplot(data=data,aes(x=dbh,y=age))+
geom_point(mapping=aes(alpha=0.01))+
coord_fixed()
png(outpic,height=960, width=960, res=144)
print(p)
dev.off()