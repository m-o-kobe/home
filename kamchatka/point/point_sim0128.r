library(spatstat)
library(ggplot2)
type="int"
spp="lc"
ctr<-read.csv("ctrl0315.csv")
datap<-subset(ctr,ctr$spp=="bp")
databp<-subset(datap,datap$X.num==datap$sprout)
datanotbp<-subset(ctr,ctr$spp!="bp")
data_kabunasi<-rbind(databp,datanotbp)
data_kabunasi<-subset(data_kabunasi,data_kabunasi$dbh01>0.0001)
ppp_ctr<-ppp(x=data_kabunasi$x,y=data_kabunasi$y,window=owin(c(0,100),c(0,50)),marks=data_kabunasi$spp)
f1 <- function(X) { marks(X) == spp }
f2<-function(X ){marks(X)!="nodata"}

ctr_k<-Kmulti(ppp_ctr,I=f1,J=f2,correction="Ripley")


i=3
#year=200
year=160
#filename=paste("output/pp2/output0127ctr_pp",i,".csv",sep="")
filename=paste("output/pp3/output0127ctr_pp",i,".csv",sep="")

data<-read.csv(filename,header = FALSE)
dat<-subset(data,data$V1==year)
dat<-subset(dat,dat$V6>0.0001)
colnames(dat)[4]<-"sp"
dat$sp[dat$sp==1]<-"lc"
dat$sp[dat$sp==2]<-"bp"
dat$sp[dat$sp==3]<-"pt"

if ( type=="int" ){
  pppdata<-ppp(x=dat$V2,y=dat$V3,
               window=owin(c(0,50),c(0,100)),
               marks = dat$sp)
  
}else{
  pppdata<-ppp(x=dat$V2,y=dat$V3,
               window=owin(c(0,100),c(0,50)),
               marks = dat$sp)
}
#data_k<-Kest(pppdata,correction="Ripley")
data_k<-Kmulti(pppdata,fun=Kmulti,I=f1,J=f2,correction="Ripley")

#plot(pppdata)
#summary(pppdata)
plot(data_k,sqrt(./pi)-r~r)


fitted_r_p<-data_k$r
kotaisu<-c()



for (i in 1:50) {
  #filename=paste("output/pp/output0127ctr_pp",i,".csv",sep="")
  filename=paste("output/pp3/output0127ctr_pp",i,".csv",sep="")
  
  data<-read.csv(filename,header = FALSE)
  dat<-subset(data,data$V1==year)
  dat<-subset(dat,dat$V6>0.0001)
  colnames(dat)[4]<-"sp"
  dat$sp[dat$sp==1]<-"lc"
  dat$sp[dat$sp==2]<-"bp"
  dat$sp[dat$sp==3]<-"pt"
  dat$sp<-as.factor(dat$sp)
  if ( type=="int" ){
    pppdata<-ppp(x=dat$V2,y=dat$V3,
                 window=owin(c(0,50),c(0,100)),
                 marks = dat$sp)
    
  }else{
    pppdata<-ppp(x=dat$V2,y=dat$V3,
                 window=owin(c(0,100),c(0,50)),
                 marks = dat$sp)
  }
  
  
  data_k<-Kmulti(pppdata,fun=Kmulti,I=f1,J=f2,correction="Ripley")
  fitted_r_p<-cbind(fitted_r_p,data_k$iso)
  kotaisu<-append(kotaisu,nrow(subset(dat,dat$sp==spp)))
}

fitted_r_p<-fitted_r_p[,2:41]
kotaisu<-kotaisu[order(kotaisu)]

#kotaisu<-append(namae,kotaisu)
#matome<-rbind(matome,kotaisu)

#sortlist<-data_k$r

sortlist<-fitted_r_p[1,]
for(i in 2:513) {
  sortlist<-rbind(sortlist,
                  fitted_r_p[i,order(fitted_r_p[i,])])
}

#write.csv(matome,"test0112.csv")


hi_low<-cbind(data_k$r,sortlist[,1],"low")
hi_low<-rbind(hi_low,cbind(data_k$r,sortlist[,40],"hi"))
hi_low<-rbind(hi_low,cbind(ctr_k$r,ctr_k$iso,"observed"))
hi_low<-as.data.frame(hi_low)
names(hi_low)<-c("r","k","label")
hi_low$r<-as.double(as.character(hi_low$r))
hi_low$k<-as.double(as.character(hi_low$k))
hi_low$L<-sqrt(hi_low$k/pi)-hi_low$r



g1<-ggplot(data=hi_low,
           aes(x=r,y=L,colour=label))+
  #labs(title=namae)+
  xlim(0,12.5)+
  geom_line()

print(g1)
plot(pppdata)


