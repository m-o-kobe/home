library(spatstat)
library(ggplot2)
data<-read.csv("testfile1230_1.csv")

number<-1

data1<-subset(data,data$num==number)
pppdata<-ppp(x=data1$x,y=data1$y,
             window=owin(c(0,100),c(0,100)))
data_k<-Kest(pppdata,correction="Ripley")

fitted_r_p<-data_k$r

for (i in 1:160) {
  number<-i
  data1<-subset(data,data$num==number)
  pppdata<-ppp(x=data1$x,y=data1$y,
               window=owin(c(0,100),c(0,100)))
  data_k<-Kest(pppdata,correction="Ripley")
  
   fitted_r_p<-cbind(fitted_r_p,data_k$iso)
}

#sortlist<-data_k$r

sortlist<-fitted_r_p[1,]
for(i in 2:513) {
  sortlist<-rbind(sortlist,
                  fitted_r_p[i,order(fitted_r_p[i,])])
}





ctr<-read.csv("ctrl0315.csv")

datap<-subset(ctr,ctr$spp=="bp")
databp<-subset(datap,datap$X.num==datap$sprout)
datanotbp<-subset(data,data$spp!="bp")
data_kabunasi<-rbind(databp,datanotbp)

ppp_ctr<-ppp(x=data_kabunasi$x,y=data_kabunasi$y,window=owin(c(0,100),c(0,50)),marks=data_kabunasi$spp)
f1 <- function(X) { marks(X) == sp }
f2<-function(X ){marks(X)!="nodata"}
ctr_k<-Kmulti(ppp_ctr,I=f1,J=f2,correction="Ripley")
plot(ctr_k)


hi_low<-cbind(data_k$r,sortlist[,4],"low")
hi_low<-rbind(hi_low,cbind(data_k$r,sortlist[,157],"hi"))


hi_low<-rbind(hi_low,cbind(data_k$r,data_k$iso,"observed"))
hi_low<-as.data.frame(hi_low)
names(hi_low)<-c("r","k","label")
hi_low$r<-as.double(as.character(hi_low$r))
hi_low$k<-as.double(as.character(hi_low$k))
hi_low$k_hosei<-sqrt(hi_low$k/pi)-hi_low$r

g1<-ggplot(data=hi_low,
           aes(x=r,y=k_hosei,colour=label))+
  geom_line()

print(g1)
