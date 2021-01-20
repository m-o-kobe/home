library(spatstat)
library(ggplot2)
sp="lc"
ctr<-read.csv("ctrl0315.csv")
datap<-subset(ctr,ctr$spp=="bp")
databp<-subset(datap,datap$X.num==datap$sprout)
datanotbp<-subset(ctr,ctr$spp!="bp")
data_kabunasi<-rbind(databp,datanotbp)

ppp_ctr<-ppp(x=data_kabunasi$x,y=data_kabunasi$y,window=owin(c(0,100),c(0,50)),marks=data_kabunasi$spp)
f1 <- function(X) { marks(X) == sp }
f2<-function(X ){marks(X)!="nodata"}

ctr_k<-Kmulti(ppp_ctr,I=f1,J=f2,correction="Ripley")
plot(ctr_k)
matome<-c(1:80)
matome<-append("pattern",matome)


a=-2.5
b="3"
c=3.5


filename=paste("simu/test200_",c,"_",a,"_",b,".csv",sep="")
namae=paste("a=",a,", b=",b,", c=",c,sep="")

#別バージョン
filename=paste("simu/test279_200_",c,"_",a,"_",b,".csv",sep="")
namae=paste("p279 a=",a,", b=",b,", c=",c,sep="")


#別バージョン
filename=paste("simu/test2710_200_",c,"_",a,"_",b,".csv",sep="")
namae=paste("p2710 a=",a,", b=",b,", c=",c,sep="")



data<-read.csv(filename)

number<-1

data1<-subset(data,data$num==number)
pppdata<-ppp(x=data1$x,y=data1$y,
             window=owin(c(0,100),c(0,100)))
data_k<-Kest(pppdata,correction="Ripley")

fitted_r_p<-data_k$r
kotaisu<-c()

for (i in 1:80) {
  number<-i
  data1<-subset(data,data$num==number)
  data1<-subset(data1,data1$age>5)
  kotaisu<-append(kotaisu,nrow(data1))
  
  pppdata<-ppp(x=data1$x,y=data1$y,
               window=owin(c(0,50),c(0,100)))
  data_k<-Kest(pppdata,correction="Ripley")
  
   fitted_r_p<-cbind(fitted_r_p,data_k$iso)
}
kotaisu<-kotaisu[order(kotaisu)]

kotaisu<-append(namae,kotaisu)
matome<-rbind(matome,kotaisu)

#sortlist<-data_k$r

sortlist<-fitted_r_p[1,]
for(i in 2:513) {
  sortlist<-rbind(sortlist,
                  fitted_r_p[i,order(fitted_r_p[i,])])
}

#write.csv(matome,"test0112.csv")


hi_low<-cbind(data_k$r,sortlist[,2],"low")
hi_low<-rbind(hi_low,cbind(data_k$r,sortlist[,79],"hi"))
hi_low<-rbind(hi_low,cbind(ctr_k$r,ctr_k$iso,"observed"))
hi_low<-as.data.frame(hi_low)
names(hi_low)<-c("r","k","label")
hi_low$r<-as.double(as.character(hi_low$r))
hi_low$k<-as.double(as.character(hi_low$k))
hi_low$L<-sqrt(hi_low$k/pi)-hi_low$r

g1<-ggplot(data=hi_low,
           aes(x=r,y=L,colour=label))+
  labs(title=namae)+
  xlim(0,12.5)+
  geom_line()

print(g1)


