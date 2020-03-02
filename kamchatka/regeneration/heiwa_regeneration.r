library(doBy)
library(MuMIn)
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
    result[2:nrow(result),5:8] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

options(na.action = "na.fail")

df<-read.csv("regeneration/int_seedling.csv",fileEncoding = "UTF-8-BOM")
##################larix
sp="Larix"
df1<-subset(df,df$Sp.==sp)
df2<-summaryBy(formula=Hcm~x+y,data=df1,FUN =length)

map<-read.csv("crd/map_int_lc_200228.csv")

taiou=merge(df2,map,all = TRUE)
taiou$Hcm.length[is.na(taiou$Hcm.length)]=0
names(taiou)[3]<-"juv_num"

model1<-lm(formula=juv_num~Crd5+Crd10+Crd15+crd20,data=taiou)
summary(model1)

########Poplus
sp="Poplus"
df1<-subset(df,df$Sp.==sp)
df2<-summaryBy(formula=Hcm~x+y,data=df1,FUN =length)

map<-read.csv("crd/map_int_pt_200228.csv")

taiou=merge(df2,map,all = TRUE)
taiou$Hcm.length[is.na(taiou$Hcm.length)]=0
names(taiou)[3]<-"juv_num"
#########################ここから共通###########3

model1<-lm(formula=juv_num~Crd5+Crd10+Crd15+crd20,data=taiou)
summary(model1)
model2<-lm(formula=juv_num~Crd5+Crd10+Crd15+crd20+0,data=taiou)
model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)

model3<-lm(formula=juv_num~Crd15+crd20+0,data=taiou)
summary(model3)

outcsv<-paste("regeneration/heiwa_regeneration",sp,"0228.csv",sep="_")
write.csv(model_hikaku,outcsv)
tablecsv(model3,taiou,outcsv)
