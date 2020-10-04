library(MuMIn)
library(rgl)
library("colorRamps")
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

motodata<-read.csv("ronbun/sixty_years_table.csv",fileEncoding = "UTF-8-BOM")
duration<-5



data<-subset(motodata,motodata$kikan==duration)
data$dead<-data$mae_num-data$num
data$sv_num<-round(data$num)
data$d_num<-round(data$dead)
data1<-data

model1<-glm(cbind(sv_num,d_num)~BA.m.2.ha.+mae_dbh_cm+mae_year,data=data1,family=binomial)
model2<-glm(cbind(sv_num,d_num)~BA.m.2.ha.+mae_dbh_cm+mae_year+0,data=data1,family=binomial)
model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
#outcsv<-"mortality/mortality_pt_5years_cm.csv"
#write.csv(model_hikaku,outcsv)
#tablecsv(model1,data1,outcsv)
summary(model1)

data_sv<-subset(motodata,motodata$mae_num>0)
data_sv$sv_dur<-data_sv$sv/data_sv$mae_sv
data_sv$sv5<-data_sv$sv_dur^(5/data_sv$kikan)
data_sv$num5<-data_sv$mae_num*data_sv$sv5
data_sv$sv_num5<-round(data_sv$num5)
data_sv$d_num5<-round(data_sv$mae_num-data_sv$num5)

data_sv11<-subset(data_sv,data_sv$kikan<15)
data_sv7<-subset(data_sv,data_sv$kikan<10)
data_sv5<-subset(data_sv,data_sv$kikan<6)

model1<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_cm+mae_year,data=data_sv11,family=binomial)
model2<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_cm+mae_year+0,data=data_sv11,family=binomial)

model1<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_inch.suitei.+mae_year,data=data_sv11,family=binomial)
model2<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_inch.suitei.+mae_year+0,data=data_sv11,family=binomial)


summary(model1)

model1<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_inch.suitei.+mae_year,data=data_sv7,family=binomial)
summary(model1)

model1<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_inch.suitei.+mae_year,data=data_sv5,family=binomial)
model2<-glm(cbind(sv_num5,d_num5)~BA.m.2.ha.+mae_dbh_inch.suitei.+mae_year+0,data=data_sv5,family=binomial)

summary(model1)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
#outcsv<-"mortality/mortality_pt_5years_dummy_cm.csv"
#write.csv(model_hikaku,outcsv)
#tablecsv(model1,data_sv11,outcsv)


data_sv11$sv5p<-round(data_sv11$sv5*100)
cpale<-matlab.like(100)

col<-cpale[100-data_sv11$sv5p]

plot3d(data_sv11$BA.m.2.ha.,data_sv11$mae_dbh_inch.suitei.,data_sv11$mae_year,color=col)


plot3d(data_sv11$BA.m.2.ha.,data_sv11$mae_dbh_inch.suitei.,data_sv11$mae_year,col=col,type="s",radius=data_sv11$mae_num^0.5*0.1)

ace               

image(matrix(1:100,1),col=cpale)


model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
#outcsv<-paste("regeneration/ketugou",sp1,"plot_0429.csv",sep="_")
#write.csv(model_hikaku2,outcsv)
#tablecsv(model3,ketugou,outcsv)

