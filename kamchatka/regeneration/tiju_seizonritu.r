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



summary(int_child)
