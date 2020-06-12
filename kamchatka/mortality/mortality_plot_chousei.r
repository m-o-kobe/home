library(ggplot2)
motodata<-read.csv("nenrin/nenrin1.csv")
plot(x=motodata$dbh,y=motodata$age)
sp<-"lc"
data1<-subset(motodata,motodata$spp==sp)
model<-lm(age~dbh,data=data1)
summary(model)
#g<-ggplot(data=data1,mapping=aes(x=dbh,y=age))+
  geom_point()
#print(g)

ctrl<-read.csv("ctrl0315.csv")
ctrl1<-subset(ctrl,ctrl$spp==sp)
ctrl1$dbh<-ctrl1$dbh01*10
ctrl1$age<-predict(model,ctrl1)
#summary(ctrl1$age)
#summary(ctrl1)

#g1<-ggplot(data=ctrl1,mapping=aes(x=age))+
  geom_histogram()
#print(g1)


int<-read.csv("int0313.csv")
int1<-subset(int,int$spp==sp)
int1$dbh<-int1$dbh01*10
int1$age<-predict(model,int1)
#summary(int1)

#g2<-ggplot(data=int1,mapping=aes(x=age))+
  geom_histogram()
#print(g2)

int5_35<-sum(int1$age>5&int1$age<35)
ctr165_195<-sum(ctrl1$age>165&ctrl1$age<195)
seizonritu<-ctr165_195/int5_35
seizonritu1<-seizonritu^(1/160)

seizonrituout<-list()
seizonrituout[[1]]<-c(sp,"")
seizonrituout[[2]]<-c("kikan_40yr","5-35")
seizonrituout[[3]]<-c("kikan_200yr","165-195")

seizonrituout[[4]]<-c("40yr",int5_35)
seizonrituout[[5]]<-c("200yr",ctr165_195)
seizonrituout[[6]]<-c("seizonritu",seizonritu)
seizonrituout[[7]]<-c("seizonritu_1year",seizonritu1)
seizonrituout[[8]]<-c("keisuu",x)
seizonrituout
outcsv<-paste("mortality/heiwa_mortality_chousei",sp,"0610.csv",sep="_")
write.csv(seizonrituout,outcsv,col.names = FALSE,row.names = FALSE)

int2 <-read.csv("crd/crd_int_191209.csv")
int3<-subset(int2,int2$spp==sp)
summary(int3)

mean(int3$crd)
mean(int3$dbh01)
int3$seizon<-predict(data3.glm,int3,type="response")
int3$seizon1<-int3$seizon^(1/3)

int4<-merge(int3,int1)
int5<-subset(int4,int4$age>5&int4$age<35)
int5$seizon160<-int5$seizon^(160/3)


int6<-int5

for (i in 1:100000){
  x<-i*0.00001
  int6$seizon160<-int6$seizon^(x*160/3)
  sa<-mean(int6$seizon160)-ctr165_195/int5_35
  if(sa<=0){
    break
  }
}



write.csv(int5,"mortality/chousei_lc_0610.csv")
summary(int5)
