DFc<-read.csv("ds4_brand2018_c.csv")
DBcall<-subset(DFc,DFc$row=="全体")
DBcall<-subset(DBcall,DBcall$gyo2==1)
library(drc)
plot.new()
par(mfrow=c(3,4)) 
model.LL4 <- drm(C_x1 ~ C_ap3, data=DBcall, fct=LL.4())
plot(model.LL4, type="all")
plot.new()
i=10
for(j in 111:113){
  fordraw<-data.frame(b1=as.numeric(DBcall[,i]),b2=as.numeric(DBcall[,j]),col=colnames(DBcall[i])+"_"+colnames(DBcall[j]),brand_id=DBcall[1]==47)
  model.LL4<- drm(b1 ~ b2, data=fordraw, fct=LL.4())
  plot(model.LL4,type="all",main=colnames(DBcall[j]))
}
summary(model.LL4)
