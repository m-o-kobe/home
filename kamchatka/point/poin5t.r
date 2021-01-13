library(spatstat)

data<-read.csv("ctrl0315.csv")

datap<-subset(data,data$spp=="bp")
databp<-subset(datap,datap$X.num==datap$sprout)
datanotbp<-subset(data,data$spp!="bp")
data_kabunasi<-rbind(databp,datanotbp)

pppdata<-ppp(x=data_kabunasi$x,y=data_kabunasi$y,window=owin(c(0,100),c(0,50)),marks=data_kabunasi$spp)

plot(pppdata)

#data<-read.csv("int0313.csv")
#datap<-subset(data,data$spp==sp)

datap<-subset(data,data$spp=="bp")
bp_sp<-unique(datap$sprout)
bp_len<-length(bp_sp)
len<-nrow(datap)
data_bp<-datap[1,]
i=1
j=2


for (i in 1:bp_len){
  for (j in 1:len){
    if (bp_sp[i]==datap[j,8]){
      data_bp<-rbind(data_bp,datap[j,])
      break
    }
  }  
}
#datap<-subset(datap,datap$dbh01>0)
datanotbp<-subset(data,data$spp!="bp")
data_kabunasi<-rbind(data_bp,datanotbp)

pppdata<-ppp(x=data_kabunasi$x,y=data_kabunasi$y,window=owin(c(0,50),c(-50,50)),marks=data_kabunasi$spp)
plot(pppdata)
#bpの株立ち抜きの解析用

 
#単樹種のL関数
#k100<-envelope(pppdata,fun=Lest,correction="Ripley",nsim=80,nrank=2)
sp<-"lc"


f1 <- function(X) { marks(X) == sp }
f2<-function(X ){marks(X)!="nodata"}
f2<-function(X ){marks(X)!=sp}

k100<-envelope(pppdata,fun=Kmulti,I=f1,J=f2,correction="Ripley",nsim=160,nrank=4)

#作図
plot(k100,sqrt(./pi)-r~r,main = sp)

#plot(k100,.-r~r)

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