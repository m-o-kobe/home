library(spatstat)

data<-read.csv("../../0822toutsuba.csv")
pppdata<-ppp(x=data$X,y=data$Y,window=owin(c(-20,80),c(0,40)),marks=data$spp)
kdata<-Kmulti(pppdata,marks(pppdata)=="tou",marks(pppdata)=="tsuba",correction="Ripley")
ldata<-Lcross(pppdata,"tou","tsuba",correction="Ripley")

k100<-envelope(pppdata,Kcross,i="tou",j="tsuba",correction="Ripley",nsim=100)

k100as<-as.function(k100)
print(k100as(1))
png("../../harasan.png",height=960, width=960, res=144)
plot(k100,sqrt(./pi)-r~r)
dev.off()
