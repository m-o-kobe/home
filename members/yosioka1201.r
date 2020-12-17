library(spatstat)

data1<-read.csv("members/sportspark_planting_pointprocess.csv")
data2<-subset(data1,data1$Planting!="侵入")

pppdata1<-ppp(x=data1$x,y=data1$y,window=owin(c(0,20),c(0,9)),marks=data1$Planting)

pppdata2<-ppp(x=data2$x,y=data2$y,window=owin(c(0,20),c(0,9)),marks=data2$Planting)


result_pcf<-envelope(pppdata1,fun=pcf,nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")

plot(result_pcf)
result_lest<-envelope(pppdata1,fun=Lest,nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")
result_lest<-envelope(pppdata1,fun=Lest,nsim=1000,nrank=25,normalise=FALSE,kernel="epanechnikov")

#plot(result_kest,sqrt(./pi)-r~r)
plot(result_lest,.-r~r)

result_mk<-envelope(pppdata2,fun=markcorr,nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")
plot(result_mk)
#x:0~20,y:0~10

result_kcross<-envelope(pppdata2,Kcross,i="更新",j="植栽",correction="Ripley",nsim=80,nrank=2)

plot(result_kcross,sqrt(./pi)-r~r)


#csv出力用
k100<-result_kcross
valuek<-fvnames(k100,a=".")
k100as<-as.function(k100,value=valuek)
kmatome<-data.frame(r=seq(0,max(k100$r),0.05))
kmatome$theo<-k100as(kmatome$r,"theo")
kmatome$obs<-k100as(kmatome$r,"obs")
kmatome$hi<-k100as(kmatome$r,"hi")
kmatome$lo<-k100as(kmatome$r,"lo")
write.csv(kmatome,"yosioka.csv")
