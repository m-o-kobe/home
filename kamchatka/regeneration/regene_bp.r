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

sp="bp"
motodata<-read.csv("nenrin/nenrin1.csv")
data1<-subset(motodata,motodata$spp==sp)
model<-lm(age~dbh,data=data1)

int<-read.csv("int0313.csv")
int1<-subset(int,int$spp==sp)
int1$dbh<-int1$dbh01*10
int1$age<-predict(model,int1)
#summary(int1)

as.integer(-8.0/5)*5
summary(int1)
int1$X<-as.integer(int1$x/5)*5
int1$Y<-as.integer((int1$y+50)/5)*5-50
#int_p<-subset(int1,int1$age>5)
int_c<-subset(int1,int1$age<=5)

int_c$x<-int_c$X
int_c$y<-int_c$Y

df2<-summaryBy(formula=dbh~x+y,data=int_c,FUN =c( length,mean))

map<-read.csv("crd/map_int_bp_200415.csv")

taiou=merge(df2,map,all = TRUE)
taiou$dbh.length[is.na(taiou$dbh.length)]=0
taiou$dbh.mean[is.na(taiou$dbh.mean)]=0
taiou$ssp5_<-taiou$ssp5-taiou$dbh.length*taiou$dbh.mean
names(taiou)[3]<-"juv_num"


model1<-lm(formula=juv_num~ssp5_+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20,data=taiou)
model2<-lm(formula=juv_num~ssp5_+ssp10+ssp15+ssp20+dsp5+dsp10+dsp15+dsp20+0,data=taiou)
summary(model1)
summary(model2)
model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
model3<-lm(formula=juv_num~ssp5_+0,data=taiou)
summary(model3)
prenum<-predict(model3,taiou)
summary(prenum)
prenum
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
