###fireの場合にdspも含めた解析をしようとしたがここでインポートしてるファイルは火災後のdspっぽい
###火災前のdspの計算が必要かも


library(dplyr)
library(ggplot2)
library(GGally)
library(MuMIn)
library(doBy)
options(na.action = "na.fail")
tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  N <- nrow(data)
  AIC <- AIC(datalm)
  R_squared<-sum$r.squared
  adjusted_R_squared<-sum$adj.r.squared
  
  result <- cbind(coe,AIC,N,R_squared,adjusted_R_squared)
  ro<-nrow(result)
  if(ro>1){
    result[2:nrow(result),5:6] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}


###poplusの場合



int_parent<-read.csv("crd/map_int_pt_200415.csv")
ctr_parent<-read.csv("crd/map_ctr_pt_200415.csv")
fire_parent<-read.csv("crd/map_fire_Po_200415.csv")
fire_child1<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
fire_child2<-read.csv("regeneration/fire_seedling.csv",fileEncoding = "UTF-8-BOM")
fire_child3<-read.csv("regeneration/fire_seedling_new.csv",fileEncoding = "UTF-8-BOM")
fire_child31<-merge(fire_child2,fire_child3,all = TRUE)
fire_child31$SP[fire_child31$SP=="La"]<-"Larix"
fire_child31$SP[fire_child31$SP=="Be"]<-"Betula"
fire_child31$SP[fire_child31$SP=="Po"]<-"Populus"
int_child<-read.csv("regeneration/int_seedling.csv",fileEncoding = "UTF-8-BOM")
ctr_child<-read.csv("regeneration/ctr_seedling04.csv",fileEncoding = "UTF-8-BOM")
sp1="Poplus"
sp2="pt"
###ここまでpoplusの場合




int1<-subset(int_child,int_child$Sp.==sp1)
int2<-summaryBy(formula=Hcm~x+y,data=int1,FUN =length)
int3<-merge(int_parent,int2,all = TRUE)
int3$Hcm.length[is.na(int3$Hcm.length)]<-0
int3$plot<-"int"
names(int3)[11] <- "juv_num"


fire_child32<-subset(fire_child31,fire_child31$SP==sp1)
fire_child321<-subset(fire_child32,fire_child32$Hcm04!="dead")
fire_child33<-summaryBy(formula=Hcm04~x+y,data=fire_child321,FUN = length)

fire1<-merge(fire_parent,fire_child33,all=TRUE)
fire2<-merge(fire1,fire_child1,all=TRUE)

fire2$Hcm04.length[is.na(fire2$Hcm04.length)]<-0
fire2$plot<-"fire"
fire2$juv_num<-fire2$Po_sucker2004+fire2$Hcm04.length
fire2$juv_num2000<-fire2$Po_sucker2000
fire3<-subset(fire2,!is.na(fire2$juv_num2000))

ctr_child32<-subset(ctr_child,ctr_child$sp.=="Poplus")
ctr_child33<-summaryBy(formula=No~x+y,FUN = length,data=ctr_child32)
ctr1<-merge(ctr_parent,ctr_child33,all = TRUE)
names(ctr1)[11]<-"juv_num"
ctr1$plot<-"ctr"
ctr1$juv_num[is.na(ctr1$juv_num)]<-0
ketugou<-merge(ctr1,int3,all=TRUE)
ketugou<-merge(ketugou,fire2,all=TRUE)
ketugou<-subset(ketugou,!is.na(ketugou$juv_num))
ketugou<-subset(ketugou,ketugou$plot=="fire")


#point/fire_intensity.rからintensityを引っ張ってくる
len<-nrow(fire3)
for(i in 1:len){
  fire_intensity<-intensity2[fire3$y[i]+3,fire3$x[i]+3]
  fire3$fire[i]<-as.numeric(fire_intensity)
}



g1<-ggpairs(data=fire3,columns = c(3:10,25:26),mapping = aes(color = plot))
print(g1)
model1<-lm(juv_num2000~ssp5+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+fire,data=fire3)
model2<-lm(juv_num2000~ssp5+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+fire+0,data=fire3)

summary(model1)
model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
#model3<-lm(juv_num~ssp20+dsp20,data=ketugou)
#model3<-lm(juv_num~ssp15+ssp20+0,data=ketugou)

summary(model3)
#outcsv<-paste("regeneration/ketugou",sp1,"0429.csv",sep="_")
#write.csv(model_hikaku,outcsv)
#tablecsv(model3,ketugou,outcsv)
model2<-lm(juv_num~ssp5+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+plot+0,data=ketugou)
summary(model2)
model_hikaku2<-dredge(model2,rank="BIC")
#model3<-lm(juv_num~ssp10+plot+0,data=ketugou)

summary(model3)
#outcsv<-paste("regeneration/ketugou",sp1,"plot_0429.csv",sep="_")
#write.csv(model_hikaku2,outcsv)
#tablecsv(model3,ketugou,outcsv)


ketugou2<-ketugou
ketugou2$plot[ketugou2$plot=="fire"]<-4
ketugou2$plot[ketugou2$plot=="int"]<-40
ketugou2$plot[ketugou2$plot=="ctr"]<-200
ketugou2$plot<-as.integer(ketugou2$plot)


model1<-lm(juv_num~ssp5+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+plot,data=ketugou2)
model2<-lm(juv_num~ssp5+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+plot+0,data=ketugou2)
model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)

#model3<-lm(juv_num~dsp20+plot,data=ketugou2)
summary(model3)
#outcsv<-paste("regeneration/ketugou",sp1,"nensu_0429.csv",sep="_")
#write.csv(model_hikaku,outcsv)
#tablecsv(model3,ketugou2,outcsv)
