library(spatstat)

data<-read.csv("../../0822toutsuba.csv")
pppdata<-ppp(x=data$X,y=data$Y,window=owin(c(-20,80),c(0,40)),marks=data$spp)

k100<-envelope(pppdata,Kcross,i="tou",j="tsuba",correction="Ripley",nsim=1000,nrank=25)
valuek<-fvnames(k100,a=".")


k100as<-as.function(k100,value=valuek)

kmatome<-data.frame(r=seq(0,10,0.01))
kmatome$theo<-k100as(kmatome$r,"theo")
kmatome$obs<-k100as(kmatome$r,"obs")
kmatome$hi<-k100as(kmatome$r,"hi")
kmatome$lo<-k100as(kmatome$r,"lo")
png("../../harasan.png",height=960, width=960, res=144)
plot(k100,sqrt(./pi)-r~r)
dev.off()
write.csv(kmatome,"../../harasan.csv")
